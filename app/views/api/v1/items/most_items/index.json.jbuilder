json.array! @most_items do |item|
  json.(item, :id, :name, :description, :merchant_id)
  json.unit_price item.unit_price_in_dollars
end
