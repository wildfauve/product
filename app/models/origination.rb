class Origination
  
  include Wisper::Publisher

  include Mongoid::Document
  include Mongoid::Timestamps  

  field :party, type: String 
  field :account_url, type: String
  field :been_validated, type: Boolean, default: true

  belongs_to :sales_product
  
  def self.create_me(buy_msg: nil, requires_validation: nil)
    o = self.new
    o.been_validated = !requires_validation
    o.party = buy_msg[:customer][:_links][:self][:href]
    o.save
    o
  end
  
  def create_account
    account = AccountsPort.new.create_new_account(self)
    self.account_url = account.link_for(rel: "self")
    self.save
    account
  end
  
  def state
    self.been_validated ? :purchased : :in_progress
  end
  
  def remove
    AccountsPort.new.reset_account(link: self.account_url)
    self.delete
    publish(:success_remove_event, self)
  end
  
  def party_by_value
    self.party
=begin
    resp = CustomerPort.new.get_customer(url: self.party)
    if resp.status == :ok
      raise
      resp.party
    else
      nil
    end
=end
  end

end