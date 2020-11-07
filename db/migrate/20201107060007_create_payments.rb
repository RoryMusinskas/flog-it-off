class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.references :collection, null: false, foreign_key: true
      t.integer :buyer_id
      t.timestamp :date_paid

      t.timestamps
    end
  end
end
