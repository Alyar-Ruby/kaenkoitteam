class CreateKaenkoSettings < ActiveRecord::Migration
  def change
    create_table :kaenko_settings do |t|
      t.decimal :business_commission
      t.datetime :date_time
      t.string :timezone
      t.timestamps
    end
  end
end
