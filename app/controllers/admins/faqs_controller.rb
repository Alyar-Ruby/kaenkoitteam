# encoding: utf-8
class Admins::FaqsController < ApplicationController
	skip_before_filter :authenticate_user!
	before_filter :authenticate_admin!
  layout "admin"
  before_filter "active_tab('Faqs')"
	respond_to :html, :js, :json
	
	def index
		@faqs = Faq.all
	end
	
  def new
		@faq = Faq.new
	end
	
	def edit
		@faq = Faq.find(params[:id])
	end
  
	def create
		@faq = Faq.new(faq_params)
		if @faq.save
			redirect_to faqs_path
		else
			render :new
		end
	end
	
	def update
		@faq = Faq.find(params[:id])
		if @faq.update_attributes(faq_params)
			redirect_to faqs_path
		else
			render :edit
		end
	end
	
  def destroy
		@faq = Faq.find(params[:id])
    @faq.destroy
    redirect_to faqs_path
  end
  
	private

  def faq_params
    params.require(:faq).permit(:question, :answer)
  end
end
