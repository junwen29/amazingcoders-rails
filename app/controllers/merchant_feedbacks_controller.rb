class MerchantFeedbacksController < ApplicationController
  before_filter :authenticate_merchant!, except: [:home]

  def new
      @merchant_feedback = MerchantFeedback.new
  end


  def create
    merchant_feedback = Merchant.find(merchant_id).merchant_feedbacks.new(feedback_params)

    if merchant_feedback.save
      flash[:success] = "Feedback successfully submitted!"
      redirect_to merchant_feedback
      # Send out confirmation email
      FeedbackMailer.merchant_feedback_email(MerchantService.get_email(merchant_id), merchant_feedback).deliver
    else
      flash[:error] = "Failed to submit feedback."
      render 'new'
    end
  end

   def index
     @merchant_feedbacks = MerchantFeedback.where(:merchant_id => merchant_id)
   end

  def show
    @merchant_feedback = MerchantFeedback.find(params[:id])
    unless session[:merchant_id] == @merchant_feedback.merchant_id
      flash[:error] = "You don't have access to this page!"
      redirect_to merchant_feedbacks_path
      return
    end
  end

  private
  def feedback_params
    params.require(:merchant_feedback).permit(:title, :category, :content)
  end
end

