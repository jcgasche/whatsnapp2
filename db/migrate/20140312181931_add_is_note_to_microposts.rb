class AddIsNoteToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :is_note, :boolean
  end
end
