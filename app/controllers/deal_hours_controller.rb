class DealHoursController < ApplicationController
  before_action :set_deal_hour, only: [:show, :edit, :update, :destroy]

  # GET /deal_hours
  # GET /deal_hours.json
  def index
    @deal_hours = DealHour.all
  end

  # GET /deal_hours/1
  # GET /deal_hours/1.json
  def show
  end

  # GET /deal_hours/new
  def new
    @deal_hour = DealHour.new
  end

  # GET /deal_hours/1/edit
  def edit
  end

  # POST /deal_hours
  # POST /deal_hours.json
  def create
    @deal_hour = DealHour.new(deal_hour_params)

    respond_to do |format|
      if @deal_hour.save
        format.html { redirect_to @deal_hour, notice: 'Deal hour was successfully created.' }
        format.json { render :show, status: :created, location: @deal_hour }
      else
        format.html { render :new }
        format.json { render json: @deal_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deal_hours/1
  # PATCH/PUT /deal_hours/1.json
  def update
    respond_to do |format|
      if @deal_hour.update(deal_hour_params)
        format.html { redirect_to @deal_hour, notice: 'Deal hour was successfully updated.' }
        format.json { render :show, status: :ok, location: @deal_hour }
      else
        format.html { render :edit }
        format.json { render json: @deal_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deal_hours/1
  # DELETE /deal_hours/1.json
  def destroy
    @deal_hour.destroy
    respond_to do |format|
      format.html { redirect_to deal_hours_url, notice: 'Deal_hour was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_deal_hour
    @deal_hours = DealHour.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def deal_hour_params
    params.require(:deal_hour).permit(:day, :started_at, :ended_at)
  end
end
