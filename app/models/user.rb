class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: %i[buyer seller]
  has_many :collections, foreign_key: 'seller_id', class_name: 'Collection'
  has_many :payments, foreign_key: 'buyer_id', class_name: 'Payment'
end
