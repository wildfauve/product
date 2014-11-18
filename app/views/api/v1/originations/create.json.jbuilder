json.kind "product_origination"
json.state :purchased
json.name @prod.name
json._links do
  json.self do
    json.href api_v1_sales_product_origination_url(@prod, @prod.purchase)
  end
  json.product do
    json.href api_v1_sales_product_url(@prod)
  end
  json.account do
    json.href @prod.account.link_for(rel: :self)
  end
end