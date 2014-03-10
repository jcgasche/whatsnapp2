class AddNotesToRelationships < ActiveRecord::Migration
  def change
    add_column :relationships, :notes, :string
    add_column :relationships, :accepted, :boolean, default: false
  end
end
