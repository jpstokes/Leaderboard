class CreateLeaderboards < ActiveRecord::Migration
  def change
    create_table :leaderboards do |t|
      t.string :name
      t.integer :score

      t.timestamps null: false
    end
  end
end
