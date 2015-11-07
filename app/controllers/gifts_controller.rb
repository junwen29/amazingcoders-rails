class GiftsController < InheritedResources::Base

  def index
    @gifts = Gift.all
    @merchant = Merchant.find(merchant_id)
  end

  def show
    @merchant = Merchant.find(merchant_id)
    points = Merchant.find(merchant_id).total_points
    gift = Gift.find(params[:id])
    if points >= gift.points

      if gift.name == "1 free month"
        @payment = Payment.new
        @upcoming_payments = Payment.where("merchant_id = ? AND paid = ? AND expiry_date >= ?", session[:merchant_id], true, Date.today)

        render 'payments/gift_extend'
        #redirect_to gift_extend_path
      else
        flash[:success] = "'" + gift.name + "' redeemed! Please check your email on the details of collection"
        reason = "Redeemed " + gift.name
        MerchantPointService.new_point(reason, gift.points, "Debit", merchant_id)
        # Send out payment acknowledgement email
        GiftMailer.gift_email("Valued Merchant", @merchant, gift, MerchantService.get_email(merchant_id)).deliver

        redirect_to merchant_points_path
      end

    else
      flash[:error] = "Insufficient Points!"
      redirect_to gifts_path
    end
  end



  private
  def gift_params
    params.require(:gift).permit(:name, :points, :description, :gift_type)
  end
end

