class PackagesController < InheritedResources::Base

  def index
    @packages = Package.all
    @merchant = Merchant.find(merchant_id)
  end


    def package_params
      params.require(:package).permit(:name, :points, :description, :package_type)
    end
end

