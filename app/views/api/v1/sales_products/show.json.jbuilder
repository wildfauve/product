json.kind "sales_product"
json.name @sales_product.name
json.desc @sales_product.desc
json._links do
  json.self do
    json.href api_v1_sales_product_url(@sales_product)
  end
end  
