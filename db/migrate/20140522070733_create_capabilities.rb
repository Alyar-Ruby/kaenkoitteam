class CreateCapabilities < ActiveRecord::Migration
  def change
    create_table :capabilities do |t|
    	t.string :title
      t.timestamps
    end
  end
end
