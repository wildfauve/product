json.kind "sales_products"
json.sales_products @sales_products do |sp|
  json.name sp.name
  json.desc sp.desc
  json.requires_validation sp.requires_validation
  json._links do
    json.self do
      json.href api_v1_sales_product_url(sp)
    end
    json.product_originations do
      json.href api_v1_sales_product_originations_url(sp)
    end
  end  
end
json._links do
  json.self do
    json.href api_v1_sales_products_url
  end
end
