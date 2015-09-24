class Api::P1::DealsController < Api::P1::ApplicationController

  def index
    # TODO change to active deals only
    deals = Deal.all
    render_jbuilders(deals) do |json,deal|
      # json.(deal, :id, :title)
      deal.to_json json
    end
  end

  def show
    # all_details = []
    deal = Deal.find(params[:deal_id])
    # days = DealDay.where(:deal_id => params[:deal_id])
    # time = []
    # days.each do |d|
    #   time << DealTime.where(:deal_day_id => d.id)
    # end
    # all_details << deal
    # all_details << days
    # all_details << time
    render_jbuilder do |json|
      deal.all_to_json(json)
      # json.set! :deal_days do
      #   json.array!(deal.deal_days, :id, :deal_id, :mon, :tue, :wed, :thur, :fri, :sat, :sun)
      #   days = DealDay.where(:deal_id => params[:deal_id])
      #   days.each do |d|
      #       json.array!(d.deal_times, :deal_day_id, :started_at, :ended_at)
      #   end
      # end
    end
  end
end