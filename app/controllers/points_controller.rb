class PointsController < InheritedResources::Base


  def index
    @points = MerchantService.get_all_points(merchant_id)
    @merchant = Merchant.find(merchant_id)
  end

  def point_params
    params.require(:point).permit(:burps, :operation, :reason


    )
  end


end

