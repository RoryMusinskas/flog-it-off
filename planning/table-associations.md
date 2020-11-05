Users

- has many optional collections
  - has_many :collections, :foreign_key => 'seller_id', class_name: 'Collection'
- has many optional payments
  - has_many :payments, :foreign_key => 'buyer_id', class_name: 'Payment'

Payments

- belongs to user
  - belongs_to :buyer, :foreign_key => 'buyer_id', class_name: 'User'
- belongs to Collection

Collections

- belongs to a user
  - belongs_to :seller, :foreign_key => 'seller_id', class_name: 'User'
- has one payment
- has many categories, through collection_categories
- has one address

Collections_Categories

- belongs to collection
- belongs to categories

Categories

- has many collections, through collection_categories

Addresses

- belongs to collections
