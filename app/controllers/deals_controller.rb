class DealsController < ApplicationController
  before_action :set_deal, only: [:show, :edit, :update, :destroy]

  def new
    @deal = Deal.new
    @deal.deal_hours.build
  end

  def edit
  end

  def index
    @deal = Deal.all
  end

  def create  
    #for database
    @deal = Deal.new(deal_params)

    respond_to do |format|
      if @deal.save
        format.html { redirect_to @deal, notice: 'Deal was successfully created.' }
        format.json { render :show, status: :created, location: @deal }
      else
        format.html { render :new }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
        end
    end
  end

  def update
    respond_to do |format|
      if @deal.update(deal_params)
        format.html { redirect_to @deal, notice: 'Deal was successfully updated.' }
        format.json { render :show, status: :ok, location: @deal }
      else
        format.html { render :edit }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @deal = Deal.find(params[:id])
  end

  def destroy
    @deal = Deal.find(params[:id])
    @deal.destroy
    redirect_to deals_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_deal
    @deal = Deal.find(params[:id])
  end

  private
  def deal_params
    params.require(:deal).permit(:name_of_deal, :type_of_deal, :description, :start_date, :expiry_date, :monday,
                                 :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, :monday_start,
                                 :monday_end, :tuesday_start, :tuesday_end, :wednesday_start, :wednesday_end,
                                 :thursday_start, :thursday_end, :friday_start, :friday_end, :saturday_start,
                                 :saturday_end, :sunday_start, :sunday_end, :location, :t_c, :pushed,:redeemable,
                                 :multiple_use, :image, deal_hours_attributes: [:id, :day, :started_at, :ended_at, :destroy])
  end
end

