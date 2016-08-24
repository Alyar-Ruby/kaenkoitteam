class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :country_of_incorporation
      t.string :organization_name
      t.string :organization_url
      t.string :legal_form
      t.string :registration_number
      t.date :date_of_incorporation
      t.string :industry
      t.string :country
      t.string :state
      t.text :address
      t.string :postal_code
      t.string :city
      t.timestamps
    end
  end
end
