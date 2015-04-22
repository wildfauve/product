class CustomerPort < Port
  
  class Error < StandardError ; end
  class Unavailable < Error ; end
  
  attr_accessor :party, :status

  def create_new_customer(kiwi: nil)
    circuit(:create_new_customer_port, kiwi: kiwi)
    self
  end

  def create_new_customer_port(kiwi: nil)
    conn = Faraday.new(url: Setting.services(:customers, :create))
    conn.params = customer_msg(kiwi)
    self.send_to_port(pattern: :sync, connection: {object: conn, method: :post}, response_into: "@party")    
  end
  
  def update_customer(kiwi: nil)
    circuit(:update_customer_port, kiwi: kiwi)
    self
  end
  

  def update_customer_port(kiwi: nil)
    conn = Faraday.new(url: kiwi.party_url)
    conn.params = customer_msg(kiwi)
    self.send_to_port(pattern: :sync, connection: {object: conn, method: :put}, response_into: "@party")
  end
  
  def customer_msg(kiwi)
    {
      kind: "party",
      name: kiwi[:name],
      age: kiwi[:age]
    }
  end
  
  def get_customer(url: nil)
    circuit(:get_customer_port, url: url)    
    self
  end  
  
  
  def get_customer_port(url: nil)
    conn = Faraday.new(url: url)
    self.send_to_port(pattern: :sync, connection: {object: conn, method: :get}, response_into: "@party")
  end
  
  def buy_customer_product(product_url)
    conn = Faraday.new(url: "")
  end

  
    
end