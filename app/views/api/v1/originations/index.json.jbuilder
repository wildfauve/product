json.kind "product_originations"
json.originations @sales_product.originations do |sp|
  json.validated sp.been_validated
  json._links do
    json.self do
      json.href api_v1_sales_product_origination_path(@sales_product, sp)
    end
    json.party do
      json.href sp.party
    end
    json.account do
      json.account sp.account_url
    end
  end
end