class PackagesController < InheritedResources::Base

  def index
    @packages = Package.all
    @merchant = Merchant.find(merchant_id)
  end

  def show
    @merchant = Merchant.find(merchant_id)
    points = Merchant.find(merchant_id).total_points
    @package = Package.find(params[:id])
    if points >= @package.points
      flash[:success] = "Package Redeemed!"
      reason = "Redeemed " + @package.name
      PointService.new_point(reason, @package.points, "Minus", merchant_id)

      redirect_to packages_path
    else
      flash[:error] = "Insufficient Points!"
      redirect_to packages_path
    end
  end

  def package_params
    params.require(:package).permit(:name, :points, :description, :package_type)
  end
end

