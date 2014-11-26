class RemoteAlgorithmsPort < Port
  
  attr_accessor :algs, :status, :worker
  
  def search(url: nil)
    conn = Faraday.new(url: url)
    conn.headers['Content-Type'] = 'application/json'
    status_and_parse(resp: conn.get, parse_in_to: "@algs")
    self
  end
  
  def run(url: nil, buy_msg: nil)
    conn = Faraday.new(url: url)
    conn.params = buy_msg
    conn.headers['Content-Type'] = 'application/json'
    status_and_parse(resp: conn.post, parse_in_to: "@worker")
    self    
  end
    
    
end