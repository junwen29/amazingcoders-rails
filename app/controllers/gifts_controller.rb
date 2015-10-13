class GiftsController < InheritedResources::Base

  def index
    @gifts = Gift.all
    @merchant = Merchant.find(merchant_id)
  end

  def show
    @merchant = Merchant.find(merchant_id)
    points = Merchant.find(merchant_id).total_points
    @gift = Gift.find(params[:id])
    if points >= @gift.points
      flash[:success] = "Gift Redeemed!"
      reason = "Redeemed " + @gift.name
      PointService.new_point(reason, @gift.points, "Minus", merchant_id)

      redirect_to gifts_path
    else
      flash[:error] = "Insufficient Points!"
      redirect_to gifts_path
    end
  end

  def gift_params
    params.require(:gift).permit(:name, :points, :description, :gift_type)
  end
end

