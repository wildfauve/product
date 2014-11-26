class Origination

  attr_accessor :buy_msg
  
  include Wisper::Publisher

  include Mongoid::Document
  include Mongoid::Timestamps  


  field :party, type: String 
  field :account_url, type: String
  field :been_validated, type: Boolean, default: true
  
  scope :in_progress, ->{ where(been_validated: false)}

  belongs_to :sales_product
  
  def self.create_me(buy_msg: nil, requires_validation: nil)
    o = self.new
    o.been_validated = !requires_validation
    o.party = buy_msg[:customer][:_links][:self][:href]
    o.save
    o
  end
  
  def approve
    self.been_validated = true
    self.save
    self.create_account
    publish(:successful_origination_approval, self)
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
  
  def party_name
    CustomerPort.new.get_customer(url: party).party["party"]["name"]
  end
  
  def run_algorithms(buy_msg: nil)
    @buy_msg = buy_msg
    self.sales_product.algorithms.each {|alg| alg.run(purchase: self)}
  end

end