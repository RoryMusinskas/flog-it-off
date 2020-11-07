class ChangDatetimeToIntOnCollections < ActiveRecord::Migration[6.0]
  def change
    remove_column :collections, :available_hours_morning, :datetime
    remove_column :collections, :available_hours_night, :datetime
    add_column :collections, :available_hours_morning, :integer
    add_column :collections, :available_hours_night, :integer
  end
end
