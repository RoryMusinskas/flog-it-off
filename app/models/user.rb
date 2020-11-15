class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: %i[buyer seller]
  has_many :collections, foreign_key: 'seller_id', class_name: 'Collection'
  has_many :payments, foreign_key: 'buyer_id', class_name: 'Payment'

  # Validations
  validates :email, presence: true
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :password, presence: true
  validates :password_confirmation, presence: true
  validates :time_zone, presence: true
  validates :role, presence: true
end
