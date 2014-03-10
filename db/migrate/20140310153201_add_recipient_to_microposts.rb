class AddRecipientToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :recipient_id, :integer
    add_column :microposts, :new, :boolean, default: false
  end
end
