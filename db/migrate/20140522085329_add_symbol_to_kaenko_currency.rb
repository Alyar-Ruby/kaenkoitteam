class AddSymbolToKaenkoCurrency < ActiveRecord::Migration
  def change
    add_column :kaenko_currencies, :symbol, :string, :limit=>"5"
  end
end
