# encoding: utf-8
class CirclesController < ApplicationController
	before_filter :find_circle, except: [:index, :new, :create]
	def index
		@circles = current_user.owned_circles
	end
	  
	def new
		@circle = Circle.new
    @connections = Connection.where("(to_user_id = ? or from_user_id = ?) and status = 'Approved'",current_user.id,current_user.id)
	end
	
	def create
    params[:circle][:owner_id] = current_user.id
    @error = ""
    if params[:connections].present?
			@circle = Circle.new(circle_params)
			if @circle.save
	      params[:connections].each do |uid|
	        CircleUser.create(circle_id: @circle.id, user_id: uid)
	      end
			else
	      @connections = Connection.where("(to_user_id = ? or from_user_id = ?) and status = 'Approved'",current_user.id,current_user.id)
				render :new
			end
		else
			@error = "Please select connections."
		end
	end
	
	def edit
		@circle = Circle.find(params[:id])
	end
	
	def update
    if @circle.update_attributes(circle_params)
      redirect_to circles_path :notice  => "Successfully created circle."
    else
      render :action => 'edit'
    end
	end
	
	def destroy
    @circle.destroy
    redirect_to circles_url, :notice => "Successfully destroyed circle."
	end
	
	private
	
	def find_circle
		@circle = Circle.find(params[:id])
	end
	
	def circle_params
		params.require(:circle).permit(:name, :user_tokens, :owner_id)
	end
end

