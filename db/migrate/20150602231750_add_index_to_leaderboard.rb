class AddIndexToLeaderboard < ActiveRecord::Migration
  def change
    add_index :leaderboards, :name
  end
end
