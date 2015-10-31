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
      Payment.joins(:plan_payments).where('plan_payments.plan_id' => plan_id).select(:merchant_id).distinct.count
    end

    def count_addon_payments(addon_id)
      Payment.joins(:add_on_payments).where('add_on_payments.add_on_id' => addon_id).count
    end

    def count_active_premiums(date, plan_id=1)
      all_premiums = Payment.where('start_date <= ? AND expiry_date >= ? AND paid = ?', date, date, true)
      plan_premiums = all_premiums.joins(:plan_payments).where('plan_payments.plan_id' => plan_id)
      plan_premiums.count
    end

    def get_total_payments(date = -1)
      if date == -1
        all_payments = Payment.sum(:total_cost)
      else
        all_payments = Payment.where('start_date <= ? AND expiry_date >= ? AND paid = ?', date, date, true).sum(:total_cost)
      end
      all_payments
    end

    def get_plan_payments(plan_id = 1)
      plan_payments = Payment.joins(:plan_payments).where('plan_payments.plan_id' => plan_id).sum(:total_cost)
    end

    def get_addon_payments(addon_id)
      addon_cost = AddOn.find(addon_id).cost
      addon_count = get_addon_months(addon_id)
      addon_payment = addon_cost * addon_count
    end

    def get_plan_months(plan_id = 1)
      plan_months = Payment.joins(:plan_payments).where('plan_payments.plan_id' => plan_id).sum(:months)
    end

    def get_addon_months(addon_id)
      addon_months = Payment.joins(:add_on_payments).where('add_on_payments.add_on_id' => addon_id).sum(:months)
    end

    def extend_plan(payment)
      payment.update(plan1: true, add_on1: false, add_on2: false, add_on3: false, total_cost: 0, months: 1, paid: true)
    end
  end

  class << self
    include ClassMethods
  end
end
