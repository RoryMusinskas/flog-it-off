class RemoveMethodFromPayment < ActiveRecord::Migration[6.0]
  def change
    remove_column :payments, :payment_method
  end
end
