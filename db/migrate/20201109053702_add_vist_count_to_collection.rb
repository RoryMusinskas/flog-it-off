class AddVistCountToCollection < ActiveRecord::Migration[6.0]
  def change
    add_column :collections, :visit_count, :integer
  end
end
