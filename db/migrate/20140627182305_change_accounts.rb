class ChangeAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :hipchat_room_id, :string
  end
end
