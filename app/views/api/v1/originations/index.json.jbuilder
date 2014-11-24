json.kind "product_originations"
json.originations @sales_product.originations do |sp|
  json.validated sp.been_validated
  json._links do
    json.party do
      json.href sp.party
    end
    json.account do
      json.account sp.account_url
    end
  end
end