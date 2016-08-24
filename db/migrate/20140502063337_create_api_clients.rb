class CreateApiClients < ActiveRecord::Migration
  def change
    create_table :api_clients do |t|
    	t.string :email
    	t.string :client_id
    	t.string :client_secret
      t.timestamps
    end
  end
end
