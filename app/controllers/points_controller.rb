class PointsController < InheritedResources::Base


  def index
    @points = MerchantService.get_all_points(merchant_id)
    @merchant = Merchant.find(merchant_id)
  end

  def point_params
    params.require(:point).permit(:burps, :operation, :reason)
  end

  def new
    @point = Point.last
    @merchant = Merchant.find(@point.merchant_id)
    total_points = @merchant.total_points
    total_points += @point.burps
  end

  def create

  end

end

