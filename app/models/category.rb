class Category < ApplicationRecord
  has_many :collection_categories
  has_many :collections, through: :collection_categories
end
