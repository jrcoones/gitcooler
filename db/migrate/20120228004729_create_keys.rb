class CreateKeys < ActiveRecord::Migration
  def change
    create_table :keys do |t|
      t.integer :user_id
      t.string :name
      t.string :blob
      t.string :algorithm, :limit => 7

      t.timestamps
    end
  end
end
