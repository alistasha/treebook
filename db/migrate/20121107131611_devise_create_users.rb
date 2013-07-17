class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :first_name
      t.string :last_name
      t.string :profile_name

      ## Database authenticatable
      t.string :email,              :null => false, :default => ""
      # We don't want to store the password in plain text for security reaseons.
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      # What the timestamps column does is add two fields for created and update times.
      # What'll happend is when a user is created, the time and date of that creation will be stored in the database.
      # If they ever change their email address or update their password, the updated at time will change as well.
      t.timestamps
    end

    # Adding an index is something that you'll want to do for any column you inted to query on.
    # Since we're going to find people by their email address and also their apssword reset token, 
    # those are things we'd want to add an index for.
    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
  end
end
