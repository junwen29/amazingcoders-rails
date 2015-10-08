class FeedbacksController < ApplicationController
  before_filter :authenticate_merchant!, except: [:home, :help]

  def new
    @feedback = Feedback.new
    # Get data required for form
  end

  def errors
    #this is error method
  end

  def create
    @feedback = Merchant.find(merchant_id).feedbacks.new(feedback_params)

    if @feedback.save
      flash[:success] = "Feedback successfully submitted!"
      redirect_to @feedback
    else
      flash[:error] = "Failed to submit feedback."
      render 'new'
    end
  end

   def index
     @feedbacks = Feedback.where(:merchant_id => merchant_id)
   end

  def feedback_params
    params.require(:feedback).permit(:title, :category, :content)
  end

  def show
    @feedback = Feedback.find(params[:id])
  end

  # def edit
  #   @feedback = Feedback.find(params[:id])
  #
  #   # Get data required for dashboard
  #   @feedbacks = Feedback.all
  #
  #   # Get data required for form
  # end
  #
  # def update
  #   if @feedback.update(feedback_params)
  #     flash[:success] = "Feedback successfully updated!"
  #     redirect_to @feedback
  #   else
  #     flash[:error] = "Failed to update feedback!"
  #     render 'new'
  #   end
  # end
end

