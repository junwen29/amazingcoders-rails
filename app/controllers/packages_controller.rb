class PackagesController < InheritedResources::Base

  private

    def package_params
      params.require(:package).permit()
    end
end

