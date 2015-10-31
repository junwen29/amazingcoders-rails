class MerchantPointsController < InheritedResources::Base


  def index
    @points = MerchantService.get_all_points(merchant_id)
    @merchant = Merchant.find(merchant_id)
  end

  private
  def merchant_point_params
    params.require(:point).permit(:points, :operation, :reason)
  end
end

