module API
  module V1
    class Base < Grape::API
      mount API::V1::Messages
      mount API::V1::Auth
      mount API::V1::Transactions
      mount API::V1::Circles

      
    end
  end
end
