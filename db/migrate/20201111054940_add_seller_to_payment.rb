class AddSellerToPayment < ActiveRecord::Migration[6.0]
  def change
    add_column :payments, :seller_id, :integer
  end
end
