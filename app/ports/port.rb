class Port
  
  class Error < StandardError ; end
  class Unavailable < Error ; end
  class HTTP_Error < Error ; end 

  def link_for(rel: nil)
    @msg["_links"][rel.to_s]["href"]
  end

  def circuit(method, *args)
    if args.empty?
      cb = CircuitBreaker.new(availability: :wait, method: method) { self.send(method) }
    else
      cb = CircuitBreaker.new(availability: :wait, method: method) { |arg| self.send(method, arg) }
    end
    begin
      cb.call(args[0])
      raise Port::HTTP_Error, "{@http_status}" if @status == :not_ok
    rescue CircuitBreaker::Error => e
      raise Port::Unavailable, "#{method.to_s} Service is not Available"
    end
  end  

  def send_to_port(pattern: nil, connection: nil, response_into: nil)
    resp = self.send(pattern, connection: connection)
    instance_variable_set(response_into, @msg)
  end
    
  def sync(connection: nil)
    resp = connection[:object].send(connection[:method])
    @http_status = resp.status
    if @http_status < 300
      @status = :ok
      @msg = JSON.parse(resp.body)
    else
      @status = :not_ok
      #@status = JSON.parse(resp.body)["status"].to_sym            
    end
  end  
  
end
