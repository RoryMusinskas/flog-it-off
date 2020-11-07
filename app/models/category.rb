class Category < ApplicationRecord
  has_many :collections, through: :collection_category
end
