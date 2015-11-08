class PlansController < ApplicationController
  before_filter :authenticate_merchant!, except: [:home, :help]

  def new
    @plan = Plan.new
    #  @plan = Plan.all
  end

  def edit
    @plan = Plan.find(params[:id])
  end

  def index
    @plan = Plan.all
  end

  def create
    #for database
    @plan = Plan.new(plan_params)

    if @plan.save
      redirect_to @plan
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
    #redirect_to plan_path
  end

  private
  def plan_params
    params.require(:plan).permit(:name, :cost, :description)
  end

end



