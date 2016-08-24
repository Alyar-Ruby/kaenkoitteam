class CardsController < ApplicationController

  def confirm_delete
    @card = current_user.cards.find(params[:id])
    @sp_positions = [0,1,2,3,4,5].sample(3)
    @sp_positions.sort!
    @method = ""
    @action = confirm_delete_card_path(@card)
  end

	def destroy
    @error = ""
    spins = current_user.security_pin.split("")
    status = Array.new
    spins.each_with_index do |p,i|
      puts i.to_s+" :: "+p.to_s
      if params["sp_#{i}"].present?
        if params["sp_#{i}"] == p
          status << true
        else
          status << false
        end
      end
    end
    if status.include?false
      @error = "In-correct Security Pin"
    else            
      @card = current_user.cards.find(params[:id])
      if @card.destroy
        respond_to do |format|
          format.json { render json: @card, status: :created }
          format.js {
            @cards = current_user.cards.order("name")
          }
        end
      else
        respond_to do |format|
          format.json { render json: @card, status: :created }
          format.js {
            @cards = current_user.cards.order("name")
            @error = "Unable to process request. Try again later"
          }
        end
      end
    end
	end

	def make_primary
		current_user.cards.update_all({primary: false})
		@card = current_user.cards.find(params[:id])
		if @card.update_attributes(primary: true)
      respond_to do |format|
      	format.json { render json: @card, status: :created }
      	format.js {
      		@cards = current_user.cards.order("name")
      	}
      end
		else
      respond_to do |format|
      	format.json { render json: @card, status: :created }
      	format.js {
      		@cards = current_user.cards.order("name")
      	}
      end
		end
	end
  
	def new
		@card = Card.new
	end
  
	def create
    params[:card][:expiry_date] = params[:card][:expiry_year]+"-"+params[:card][:expiry_month]+"-1"
    if current_user.cards.count == 0
      params[:card][:primary] = 1
    end
		@card = current_user.cards.create(card_params)
		if @card.save
			respond_to do |format|
      	format.json { render json: @card, status: :created }
      	format.js {
      		@cards = current_user.cards.order("name")
      	}
      end
		else
      @errors = Array.new
      @card.errors.each do |key,value|
        @errors << value
      end
			respond_to do |format|
        format.json { render json: @errors, status: :created }
        format.js{
        	@errors
        }
      end
		end
	end
	
	private
	
	def card_params
		params.require(:card).permit(:name, :card_type, :expiry_date, :primary)
	end
end
