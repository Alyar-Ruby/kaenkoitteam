class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :access_token, null: false
      t.datetime :expires_at, null: false
      t.integer :api_client_id, null: false
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :api_keys, ["api_client_id"], name: "index_api_keys_on_user_id", unique: false
    add_index :api_keys, ["access_token"], name: "index_api_keys_on_access_token", unique: true
  end
end
