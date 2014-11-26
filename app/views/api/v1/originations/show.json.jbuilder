json.kind "product_origination"
json.state @origination.state
json._links do
  json.self do
    json.href api_v1_sales_product_origination_path(@sales_product, @origination)
  end
  json.party do
    json.href @origination.party
  end
  json.account do
    json.href @origination.account_url
  end
end