class Collection < ApplicationRecord
  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id'
  has_one :payment
  has_many :collection_categories
  has_many :categories, through: :collection_categories

  def coordinates
    [longitude, latitude]
  end

  def to_feature
    {
      "type": 'Feature',
      "properties": {
        "collection_id": id,
        "name_id": name,
        "description": description,
        "price": price,
        "available_until": available_until,
        "longitude": longitude,
        "latitude": latitude,
        "seller_id": seller_id
      },
      "geometry": {
        "type": 'Point',
        "coordinates": coordinates
      }
    }
  end
end
