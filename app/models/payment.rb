class Payment < ApplicationRecord
  belongs_to :collection
  belongs_to :buyer, foreign_key: 'buyer_id', class_name: 'User'
end
