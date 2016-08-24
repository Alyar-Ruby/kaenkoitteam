class AddStatusToRequestPayment < ActiveRecord::Migration
  def change
  	add_column :request_payments, :status, :string, :default => "Pending"
  end
end
