class Collection < ApplicationRecord
  # Associations related to the collection model
  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id'
  has_one :payment
  has_many :collection_categories, dependent: :destroy
  has_many :categories, through: :collection_categories
  has_one_attached :image

  # Validations for the new collection form that sellers see
  validates :name, presence: true, length: { maximum: 20 }
  validates :description, presence: true, length: { maximum: 250 }
  validates :categories, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, presence: true, numericality: { only_integer: true }
  validates :available_hours_morning, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 12 }
  validates :available_hours_night, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 12 }
  validates :available_until, presence: true
  validates :image, presence: true

  def coordinates
    [longitude, latitude]
  end

  # This adds the structure to the geojson object
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
