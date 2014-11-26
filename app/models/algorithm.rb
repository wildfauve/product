class Algorithm
  
  
  include Wisper::Publisher
  
  include Mongoid::Document
  include Mongoid::Timestamps  

  field :name, type: String 
  field :desc, type: String
  field :url, type: String
  field :workers_url, type: String
  field :selected, type: Boolean
  
  belongs_to :sales_product
  
  scope :selected, ->{ where(selected: true) }

  #{"name"=>"Credit Card Decision", "desc"=>"Given a credit card purchase event, the alg will validate the customer's credit rating and provide a decision.", "_links"=>{"self"=>{"href"=>"http://localhost:3026/api/v1/algorithms/5474dc414d6174db50000000"}, "alg_workers"=>{"href"=>"http://localhost:3026/api/v1/algorithms/5474dc414d6174db50000000/workers"}}}
  def self.find_or_replace(alg: alg)
    al = self.where(url: alg["_links"]["self"]["href"]).first
    if al
      al.update_me(alg: alg)
    else
      al = self.new.create_me(alg: alg)
    end
    al
  end
  
  def create_me(alg: nil)
    update_attrs(alg: alg)
    self.save
    publish(:successful_alg_create_event, self)
  end

  def update_me(alg: nil)
    update_attrs(alg: alg)
    self.save
    publish(:successful_alg_update_event, self)
  end
  
  def select_it
    self.selected = true
    self.save
    self
  end
  
  def update_attrs(alg: nil)
    self.name = alg["name"]
    self.desc = alg["desc"]
    self.url = alg["_links"]["self"]["href"]
    self.workers_url = alg["_links"]["alg_workers"]["href"]
  end
  
  def run(purchase: nil)
    worker = RemoteAlgorithmsPort.new.run(url: workers_url, buy_msg: purchase.buy_msg)
  end
  
    
end
