module API
  module V1
    class Circles < Grape::API
      include API::V1::Defaults
      resources :circles do
      	#=============================
      	#==== returns user circle ====
      	#=============================
        
      	get do
          authenticate!
          @circles = current_user.owned_circles
          @circles.map do |circle| 
              {name: circle.name, users: circle.users.collect{|u| u.name}}
          end
      	end
        post :create_circle do
          authenticate!
          safe_params = clean_params(params).require(:circle).permit(:name, :user_email)
          @circle = Circle.new(safe_params)
          @circle.owner_id = current_user.id
          if @circle.save
            "circle created"
          else
             @circle.errors.full_messages
          end
        end
      end
    end
  end
end
