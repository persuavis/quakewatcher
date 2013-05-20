class CreateEarthquakes < ActiveRecord::Migration
  def change
    create_table :earthquakes do |t|
      t.string :src
      t.string :eqid, :null => false
      t.string :version
      t.datetime :datetime
      t.decimal :lat, :precision => 8, :scale => 5
      t.decimal :lon, :precision => 8, :scale => 5
      t.float :magnitude
      t.float :depth
      t.integer :nst
      t.string :region
      t.text :raw

      t.timestamps
    end

    add_index(:earthquakes, :eqid, :unique => true)
  end
end
