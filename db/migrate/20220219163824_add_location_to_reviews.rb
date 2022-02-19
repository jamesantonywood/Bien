class AddLocationToReviews < ActiveRecord::Migration[6.1]
  def change

    add_column :reviews, :address, :text
    add_column :reviews, :latitude, :float
    add_column :reviews, :longitude, :float

  end
end
