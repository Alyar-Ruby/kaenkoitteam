class BanksController < ApplicationController

  def confirm_delete
    if params[:submit].present?
      
    else
      @bank = current_user.banks.find(params[:id])
      @sp_positions = [0,1,2,3,4,5].sample(3)
      @sp_positions.sort!
      @method = ""
    end
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
        @bank = current_user.banks.find(params[:id])
        if @bank.destroy
          respond_to do |format|
            format.json { render json: @bank, status: :created }
            format.js {
              @banks = current_user.banks.order("name")
            }
          end
        else
          respond_to do |format|
            format.json { render json: @bank, status: :created }
            format.js {
              @error = "Unable to process your request. Please try again."
              @banks = current_user.banks.order("name")
            }
          end
        end
      end
	end

	def make_primary
		current_user.banks.update_all({primary: false})
		@bank = current_user.banks.find(params[:id])
		if @bank.update_attributes(primary: true)
      respond_to do |format|
      	format.json { render json: @bank, status: :created }
      	format.js {
      		@banks = current_user.banks.order("name")
      	}
      end
		else
      respond_to do |format|
      	format.json { render json: @bank, status: :created }
      	format.js {
      		@banks = current_user.banks.order("name")
      	}
      end
			#notice: "Error occured to make primary. Please try again."
		end
	end
  
	def new
		@bank = Bank.new
	end
  
	def create
    if current_user.banks.count == 0
      params[:bank][:primary] = 1
    end
		@bank = current_user.banks.create(bank_params)
		if @bank.save
			respond_to do |format|
      	format.json { render json: @bank, status: :created }
      	format.js {
      		@banks = current_user.banks.order("name")
      	}
      end
		else
      @errors = Array.new
      @bank.errors.each do |key,value|
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
	
	def bank_params
		params.require(:bank).permit(:name, :kaenko_currency_id, :primary)
	end
end
