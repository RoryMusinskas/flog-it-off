class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.references :collection, null: false, foreign_key: true
      t.string :address
      t.string :city
      t.string :state

      t.timestamps
    end
  end
end
