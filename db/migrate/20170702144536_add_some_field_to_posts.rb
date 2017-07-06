class AddSomeFieldToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :picture, :string
    add_column :posts, :view_count, :integer, default: 0, null: false
  end
  add_index :posts, :view_count
end
