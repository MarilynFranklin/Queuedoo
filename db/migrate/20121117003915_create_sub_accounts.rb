class CreateSubAccounts < ActiveRecord::Migration
  def change
    create_table :sub_accounts do |t|
      t.text :twilio_account_sid
      t.text :twilio_auth_token
      t.integer :user_id

      t.timestamps
    end
  end
end
