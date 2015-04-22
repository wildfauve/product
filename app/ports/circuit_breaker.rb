class CircuitBreaker
  
  attr_accessor :invocation_timeout, :failure_threshold, :monitor
  
  class Error < StandardError ; end
  class Open < Error ; end
  class ConnectionFailure < Error ; end  
  class ConnectionTimeout < Error ; end  
  
  def initialize(availability: nil, method: nil, &block)
    @availability = availability
    @circuit = block
    @method = method
    @invocation_timeout = 0.5
    @failure_threshold = 3
    #@monitor = BreakerMonitor.new
    @reset_timeout = 0.01
    reset
  end
      
  def call(args)
    case state
    when :closed, :half_open
      begin
        result = do_call args
        record_call args
        result
      rescue Rack::Timeout::RequestTimeoutError, Faraday::ConnectionFailed
        record_failure
        if state == :open
          raise CircuitBreaker::Open, "System connection timed out"
        else
          retry
        end
      end
    when :open
      raise CircuitBreaker::Open
    else
      raise "Unreachable"
    end    
  end
    
  def do_call(args)
    #result = Timeout::timeout(@invocation_timeout) do
      result = @circuit.call args
      #end
    reset
    return result
  end
  
  def record_failure
    @failure_count += 1
    #@monitor.alert(state)
    #PortMonitor.log(method: @method, type: :timeout_failure)
    @last_failure_time = Time.now  
  end
  
  def record_call(args)
    #@monitor.call_monitor(args)
    #PortMonitor.log(method: @method, args: args)
  end

  def reset
    @failure_count = 0
    @last_failure_time = nil
    #@monitor.alert :reset_circuit  
    #PortMonitor.log(method: @method, type: :reset)    
  end
  
  def state
    case
    when (@failure_count >= @failure_threshold) && (Time.now - @last_failure_time) > @reset_timeout
      :half_open
    when (@failure_count >= @failure_threshold)
      :open
    else
      :closed
    end  
  end
  
end