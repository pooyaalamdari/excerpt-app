class AddLikesCountToQuotes < ActiveRecord::Migration[8.0]
  def change
    add_column :quotes, :likes_count, :integer, default: 0
  end
end
