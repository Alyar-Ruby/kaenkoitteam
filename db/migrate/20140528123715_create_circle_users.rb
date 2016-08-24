class CreateCircleUsers < ActiveRecord::Migration
  def change
    create_table :circle_users do |t|
			t.references :circle
			t.references :user
      t.timestamps
    end
  end
end
