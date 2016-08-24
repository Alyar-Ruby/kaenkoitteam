class CreatePremiumRequests < ActiveRecord::Migration
  def change
    create_table :premium_requests do |t|
      t.references :account
      t.references :user
      t.text :request
      t.timestamps
    end
  end
end
