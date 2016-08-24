class CreateFeesFromTos < ActiveRecord::Migration
  def change
    create_table :fees_from_tos do |t|
      t.string :from_account
      t.string :to_account
      t.string :mode
      t.decimal :fee_percent
      t.decimal :fee_value
      t.timestamps
    end
  end
end
