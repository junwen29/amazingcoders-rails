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

    def count_addon_payments(addon_id)
      Payment.joins(:add_on_payments).where('add_on_payments.add_on_id' => addon_id).count
    end

    def get_total_payments()
      all_payments = Payment.pluck(:total_cost)
      total_premiums = 0
      all_payments.each do |p|
        total_premiums += p
      end
      total_premiums
    end

    def get_plan_payments(plan_id = 1)
      plan_payments = Payment.joins(:plan_payments).where('plan_payments.plan_id' => plan_id).pluck(:total_cost)
      total_premiums = 0
      plan_payments.each do |p|
        total_premiums += p
      end
      total_premiums
    end

    def get_addon_payments(addon_id)
      addon_payments = AddOn.joins(:add_on_payments).where('add_on_payments.add_on_id' => addon_id).pluck(:cost)
      total_premiums = 0
      addon_payments.each do |p|
        total_premiums += p
      end
      total_premiums
    end

  end

  class << self
    include ClassMethods
  end
end
