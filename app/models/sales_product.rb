class SalesProduct
  
  attr_accessor :purchase, :account
  
  include Wisper::Publisher
  
  include Mongoid::Document
  include Mongoid::Timestamps  

  field :name, type: String 
  field :desc, type: String
  field :requires_validation, type: Boolean
  
  has_many :originations
  
  def create_me(sales_prod: nil)
    update_attr(sales_prod: sales_prod)
    self.save
    publish(:successful_sales_product_create_event, self)
  end

  def update_me(sales_prod: nil)
    update_attrs(sales_prod: sales_prod)
    self.save
    publish(:successful_sales_product_update_event, self)
  end
  
  def update_attrs(sales_prod: nil)
    self.name = sales_prod[:name]
    self.desc = sales_prod[:desc]
    self.requires_validation = sales_prod[:requires_validation]    
  end
  
  def buy(buy_msg: nil)
    if IdentityAdapter.new.valid_token(id_token: buy_msg[:id_token], party_assertion: buy_msg[:customer][:_links][:self][:href])
      @purchase = Origination.create_me(buy_msg: buy_msg, requires_validation: self.requires_validation)
      self.originations << @purchase
      self.save
      if @purchase.been_validated
        @account = @purchase.create_account
        publish(:successful_buy_event, self)
      else
        publish(:delayed_buy_event, self)
      end
    else
      publish(:failed_buy_event, self)
    end
  end
    
end
