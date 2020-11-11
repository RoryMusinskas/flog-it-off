class RemoveDateFromPayment < ActiveRecord::Migration[6.0]
  def change
    remove_column :payments, :date_paid
  end
end
