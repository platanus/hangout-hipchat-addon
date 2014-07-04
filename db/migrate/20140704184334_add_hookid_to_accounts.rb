class AddHookidToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :message_hook_id, :string
  end
end
