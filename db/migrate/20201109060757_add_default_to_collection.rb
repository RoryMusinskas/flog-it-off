class AddDefaultToCollection < ActiveRecord::Migration[6.0]
  def change
    change_column :collections, :visit_count, :integer, default: 0
  end
end
