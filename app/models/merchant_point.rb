class MerchantPoint < ActiveRecord::Base

  belongs_to :merchant
  after_create :edit_total

  scope :credit, -> {where("operation = ?", 'Credit')}
  scope :debit, -> {where("operation = ?", 'Debit')}

  validate :ensure_no_negative

  def ensure_no_negative
    merchant = Merchant.find(merchant_id)
    total_points = merchant.total_points
    if operation == "Debit"
      total_points -= points
    end
    if total_points < 0
      errors.add(:base, 'Merchant cannot have negative points: ' + total_points.to_s)
    end
  end

  private
  def edit_total
    @point = self
    @merchant = Merchant.find(@point.merchant_id)
    total_points = @merchant.total_points
    if @point.operation == "Credit"
      total_points += @point.points
    elsif @point.operation == "Debit"
      total_points -= @point.points
    end

    @merchant.update(total_points: total_points)
  end

end

