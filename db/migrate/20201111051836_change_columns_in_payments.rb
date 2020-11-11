class ChangeColumnsInPayments < ActiveRecord::Migration[6.0]
  def down
    remove_column :payments, :date_paid, :datetime
  end

  def up
    add_column :payments, :amount_total, :integer
    add_column :payments, :currency, :string
    add_column :payments, :payment_method, :string
    add_column :payments, :payment_status, :string
  end
end
