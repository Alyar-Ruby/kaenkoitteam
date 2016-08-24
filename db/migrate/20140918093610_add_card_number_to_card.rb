class AddCardNumberToCard < ActiveRecord::Migration
  def change
    add_column :cards, :card_number, :string
    add_column :cards, :cvv, :integer
  end
end
