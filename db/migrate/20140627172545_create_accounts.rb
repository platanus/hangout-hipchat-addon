class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.boolean :hipchat_installed
      t.string :hipchat_oauth_id
      t.string :hipchat_oauth_secret
      t.datetime :hipchat_oauth_issued_at
      t.string :hipchat_oauth_token
      t.string :hipchat_user_id
      t.string :hipchat_config_context
      t.string :hipchat_capabilities_url

      t.timestamps
    end
  end
end
