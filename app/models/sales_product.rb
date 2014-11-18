class SalesProduct
  
  attr_accessor :purchase, :account
  
  include Wisper::Publisher
  
  include Mongoid::Document
  include Mongoid::Timestamps  

  field :name, :type => String 
  field :desc, :type => String
  
  has_many :originations
  
  def create_me(sales_prod: nil)
    self.name = sales_prod[:name]
    self.desc = sales_prod[:desc]
    self.save
    publish(:successful_create_event, self)
  end
  
  def buy(buy_msg: nil)
    if IdentityAdapter.new.valid_token(id_token: buy_msg[:id_token], party_assertion: buy_msg[:customer][:_links][:self][:href])
      @purchase = Origination.create_me(buy_msg: buy_msg)
      self.originations << @purchase
      self.save
      @account = @purchase.create_account
      publish(:successful_buy_event, self)
    else
      publish(:failed_buy_event, self)
    end
  end
  
end
