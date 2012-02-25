class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.string :description
      t.string :slug

      t.timestamps
    end

    # For friendly_id
    add_index :projects, :slug, unique: true
  end
end
