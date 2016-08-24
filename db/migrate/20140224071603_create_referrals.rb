class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.string :account_type
      t.integer :levels
      t.integer :commission
      t.hstore  :commission_level
      t.timestamps
    end
  end
end
