class AccountsPort < Port
  
  include UrlHelpers
  
  attr_accessor :account
  
  def create_new_account(origination)
    conn = Faraday.new(url: Setting.services(:accounts, :create))
    conn.params = customer_msg(origination)
    resp = conn.post
    raise if resp.status >= 300
    #{"kind"=>"account", "_links"=>{"self"=>{"href"=>"http://localhost:3023/api/v1/accounts/546519ac4d617414e6030000"}}}
    @account = JSON.parse(resp.body)
    @msg = @account
    self
  end
  
  def reset_account(link: nil)
    conn = Faraday.new(url: link)
    conn.params = {reset: true}
    resp = conn.put
    #raise if resp.status >= 300
    @reset = JSON.parse(resp.body)
    @msg = @reset
    self    
  end
  
  
  def customer_msg(origination)
    {
      kind: "account",
      sales_product: {
        name: origination.sales_product.name,
        _links: {
          self: {
            href: url_helpers.api_v1_sales_product_url(origination.sales_product, host: Setting.services(:self, :host))
          }
        }        
      },
      customer: {
        _links: {
          self: {
            href: origination.party
          }
        }
      }
    }
  end
  
    
end