class CreateKaenkoCurrencies < ActiveRecord::Migration
  def change
    create_table :kaenko_currencies do |t|
      t.string :title
      t.string :unit
    end
  end
end
