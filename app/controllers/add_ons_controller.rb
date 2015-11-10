class AddOnsController < ApplicationController

  def new
    @add_on = Add_on.new

  end

  def edit
    @add_on = Add_on.find(params[:id])
  end

  def index
    @add_on = Add_on.all
  end

  def create
    #for database
    @add_on = Add_on.new(deal_params)

    if @add_on.save
      redirect_to @deal
    else
      render 'new'
    end
  end

  def update
    @add_on = Add_on.find(params[:id])

    if @add_on.update(add_on_params)
      redirect_to @add_on
    else
      render 'edit'
    end
  end

  def show
    @add_on = Add_on.find(params[:id])
  end

  def destroy
    @add_on = Add_on.find(params[:id])
    @add_on.destroy
    #redirect_to add_on_path
  end

  private
  def add_on_params
    params.require(:add_on).permit(:name, :cost, :description)
  end

end
