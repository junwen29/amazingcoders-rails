class Point < ActiveRecord::Base

  belongs_to :merchant
  after_create :edit_total


  private
  def edit_total
    @point = Point.last
    @merchant = Merchant.find(@point.merchant_id)
    total_points = @merchant.total_points
    total_points += @point.burps
    @merchant.update(total_points: total_points)
  end
end

