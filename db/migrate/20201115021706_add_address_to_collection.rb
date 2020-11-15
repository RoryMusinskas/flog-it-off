class AddAddressToCollection < ActiveRecord::Migration[6.0]
  def change
    add_column :collections, :address, :string
  end
end
