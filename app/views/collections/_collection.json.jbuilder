json.extract! collection, :id, :user_id, :name, :description, :price, :quantity, :available_hours_morning, :available_hours_night, :available_until, :longitude, :latitude, :created_at, :updated_at
json.url collection_url(collection, format: :json)
