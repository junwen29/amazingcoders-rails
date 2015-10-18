class MerchantPoint < ActiveRecord::Base

  belongs_to :merchant
  after_create :edit_total


  private
  def edit_total
    @point = MerchantPoint.last
    @merchant = Merchant.find(@point.merchant_id)
    total_points = @merchant.total_points
    if @point.operation == "Add"
      total_points += @point.points
    elsif @point.operation == "Minus"
      total_points -= @point.points
    end

    @merchant.update(total_points: total_points)
  end

end

