class PlansController < ApplicationController
  def new
  #  @plan = Plan.new
    @plan = Plan.all
  end

  def edit
    @plan = Plan.find(params[:id])
  end

  def index
    @plan = Plan.all
  end

  def create
    #for database
    @plan = Plan.new(deal_params)

    if @plan.save
      redirect_to @plan
      # Send out confirmation email
      # DealMailer.deal_email("Test Food Merchant", @deal).deliver
    else
      render 'new'
    end
  end

  def update
    @plan = Plan.find(params[:id])

    if @plan.update(plan_params)
      redirect_to @plan
    else
      render 'edit'
    end
  end

  def show
    @plan = Plan.find(params[:id])
  end

  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy
    #need not add a view for this action since redirecting to the index
    #action
         #redirect_to plan_path
  end

  private
  def plan_params
    params.require(:plan).permit(:name, :cost, :description)
  end

end



