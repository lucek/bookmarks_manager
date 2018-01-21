class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.string :name
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
    add_index :tags, :name
  end
end
