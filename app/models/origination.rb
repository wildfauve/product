class Origination
  
  include Wisper::Publisher

  include Mongoid::Document
  include Mongoid::Timestamps  

  field :party, :type => String 

  belongs_to :sales_product
  
  def self.create_me(buy_msg: nil)
    o = self.new
    o.party = buy_msg[:customer][:_links][:self][:href]
    o.save
    o
  end
  
  def create_account
    account = AccountsPort.new.create_new_account(self)
  end

end