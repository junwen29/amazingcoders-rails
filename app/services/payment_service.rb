class PaymentService

  module ClassMethods

    def get_overlapping_payments(merchant_id, new_start_date)
      all_payments = Payment.where(:merchant_id => merchant_id)
      valid_payments = all_payments.where('expiry_date >= ? AND paid = ? AND plan1 = ?', Date.today, true, true)
      overlapping_payments = valid_payments.where('expiry_date >= ?', new_start_date)
      overlapping_payments.count
    end

    def count_total_payments()
      Merchant.count
    end

    def count_plan_payments(plan_id = 1)
      Payment.joins(:plan_payments).where('plan_payments.plan_id' => plan_id).count
    end

  end

  class << self
    include ClassMethods
  end
end
