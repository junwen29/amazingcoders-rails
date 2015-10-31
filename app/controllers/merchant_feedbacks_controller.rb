class MerchantFeedbacksController < ApplicationController
  before_filter :authenticate_merchant!, except: [:home, :help]

  def new
      @merchant_feedback = MerchantFeedback.new
    # Get data required for form
  end

  def errors
    #this is error method
  end

  def create
    merchant_feedback = Merchant.find(merchant_id).merchant_feedbacks.new(feedback_params)

    if merchant_feedback.save
      flash[:success] = "MerchantFeedback successfully submitted!"
      redirect_to merchant_feedback
    else
      flash[:error] = "Failed to submit merchant_feedback."
      render 'new'
    end
  end

   def index
     @merchant_feedbacks = MerchantFeedback.where(:merchant_id => merchant_id)
   end
  def feedback_params
    params.require(:merchant_feedback).permit(:title, :category, :content)
  end

  def show
    @merchant_feedback = MerchantFeedback.find(params[:id])
    unless session[:merchant_id] == @merchant_feedback.merchant_id
      flash[:error] = "You don't have access to this page!"
      redirect_to merchant_feedbacks_path
      return
    end
  end

  # def edit
  #   @merchant_feedback = MerchantFeedback.find(params[:id])
  #
  #   # Get data required for dashboard
  #   @MerchantFeedbacks = MerchantFeedback.all
  #
  #   # Get data required for form
  # end
  #
  # def update
  #   if @merchant_feedback.update(feedback_params)
  #     flash[:success] = "MerchantFeedback successfully updated!"
  #     redirect_to @merchant_feedback
  #   else
  #     flash[:error] = "Failed to update merchant_feedback!"
  #     render 'new'
  #   end
  # end
end

