class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.string :date
      t.string :venue
      t.string :bands
      t.string :misc

      t.timestamps
    end
  end
end
