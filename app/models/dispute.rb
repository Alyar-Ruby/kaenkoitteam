class Dispute < ActiveRecord::Base
  mount_uploader :document, DisputeDocumentUploader
  belongs_to :transaction
  belongs_to :kaenko_currency
end
