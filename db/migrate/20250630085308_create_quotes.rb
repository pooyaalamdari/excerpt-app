class CreateQuotes < ActiveRecord::Migration[8.0]
  def change
    create_table :quotes do |t|
      t.text :content
      t.string :author
      t.string :book_title
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
