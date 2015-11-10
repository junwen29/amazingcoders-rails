class PaymentService

  module ClassMethods

    def get_overlapping_payments(merchant_id, start_date, months)
      all_payments = Payment.where(:merchant_id => merchant_id)
      valid_payments = all_payments.where('expiry_date >= ? AND paid = ? AND plan1 = ?', Date.today, true, true)
      overlapping_payments = valid_payments.where('start_date <= ? AND start_date >= ?', start_date.months_since(months), start_date )
      overlapping_payments1 = valid_payments.where('start_date <= ? AND expiry_date >= ?', start_date, start_date.months_since(months))
      overlapping_payments2 = valid_payments.where('expiry_date >= ? AND expiry_date <= ?', start_date, start_date.months_since(months))
      overlapping_payments.count + overlapping_payments1.count + overlapping_payments2.count
    end

    def get_overlapping_dates(merchant_id, expiry_date, months)
      all_payments = Payment.where(:merchant_id => merchant_id)
      valid_payments = all_payments.where('expiry_date >= ? AND paid = ? AND plan1 = ?', Date.today, true, true)
      overlapping_payments = valid_payments.where('start_date > ? AND start_date <= ?', expiry_date, expiry_date.months_since(months))

     # logger.debug "num overlapping: #{overalapping_payments.count.inspect}"
      overlapping_payments.count
    end

    def count_total_payments()
      Merchant.count
    end

    def count_plan_payments(plan_id = 1)
      Payment.joins(:plan_payments).where('plan_payments.plan_id' => plan_id).select(:merchant_id).distinct.count
    end

    def count_addon_payments(addon_id)
      Payment.joins(:add_on_payments).where('add_on_payments.add_on_id' => addon_id).select(:merchant_id).distinct.count
    end

    def count_unique_addon_payments(addon_id)
      Payment.joins(:add_on_payments).where('add_on_payments.add_on_id' => addon_id).select(:merchant_id).distinct.count
    end

    def count_active_premiums(date, plan_id=1)
      all_premiums = Payment.where('start_date <= ? AND expiry_date >= ? AND paid = ?', date, date, true)
      plan_premiums = all_premiums.joins(:plan_payments).where('plan_payments.plan_id' => plan_id)
      plan_premiums.count
    end

    def count_active_payments(date)
      Payment.where('start_date <= ? AND expiry_date >= ? AND paid = ?', date, date, true).count
    end

    def count_plan_addon_cross_sell(plan_id = 1, add_on_id)
      all_premiums = Payment.where('paid = ? AND plan1 = ?', true, true).select(:merchant_id).distinct.count
      addon_count = 0
      if add_on_id == 1
        addon_count = Payment.where('paid = ? AND plan1 = ? AND add_on1 = ?', true, true, true).select(:merchant_id).distinct.count
      elsif add_on_id == 2
        addon_count = Payment.where('paid = ? AND plan1 = ? AND add_on2 = ?', true, true, true).select(:merchant_id).distinct.count
      elsif add_on_id == 3
        addon_count = Payment.where('paid = ? AND plan1 = ? AND add_on3 = ?', true, true, true).select(:merchant_id).distinct.count
      end
      addon_count / all_premiums.to_f * 100
    end

    def count_addons_cross_sell(add_on1, add_on2, add_on3)
      if add_on1 && add_on2
        all_premiums = Payment.where('paid = ? AND add_on1 = ? AND add_on2 = ?',
                                     true, add_on1, add_on2).select(:merchant_id).distinct.count
      elsif add_on1 && add_on3
        all_premiums = Payment.where('paid = ? AND add_on1 = ? AND add_on3 = ?',
                                     true, add_on1, add_on3).select(:merchant_id).distinct.count
      elsif add_on2 && add_on3
        all_premiums = Payment.where('paid = ? AND add_on2 = ? AND add_on3 = ?',
                                     true, add_on2, add_on3).select(:merchant_id).distinct.count
      end

      all_premiums
    end

    def count_active_addons(date, addon_id)
      all_premiums = Payment.where('start_date <= ? AND expiry_date >= ? AND paid = ?', date, date, true)
      plan_premiums = all_premiums.joins(:add_on_payments).where('add_on_payments.add_on_id' => addon_id)
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

    def get_premiums_pro_rated(date)
      payments = Payment.all.pluck(:start_date, :expiry_date, :total_cost)
      all_premiums = 0
      payments.each do |p|
        start_date = p[0]
        end_date = p[1]
        if start_date >= date.beginning_of_month && end_date <= date.end_of_month
          all_premiums += p[2]
        elsif start_date < date.beginning_of_month && end_date > date.end_of_month
          duration_all = (end_date - start_date).to_i + 1
          duration_within = Time.days_in_month(Date.today.strftime("%m").to_i)
          all_premiums += duration_within / duration_all.to_f * p[2]
        elsif start_date < date.beginning_of_month && end_date >= date.beginning_of_month && end_date <= date.end_of_month
          duration_all = (end_date - start_date).to_i + 1
          duration_within = (end_date - date.beginning_of_month).to_i + 1
          all_premiums += duration_within / duration_all.to_f * p[2]
        elsif end_date > date.end_of_month && start_date >= date.beginning_of_month && start_date <= date.end_of_month
          duration_all = (end_date - start_date).to_i + 1
          duration_within = (date.end_of_month - start_date).to_i + 1
          all_premiums += duration_within / duration_all.to_f * p[2]
        end
      end
      all_premiums
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
      payment.update(plan1: true, add_on1: true, add_on2: true, add_on3: true, total_cost: 0, months: 1, paid: false,
                     expiry_date: payment.start_date.months_since(1))
    end

=begin
    def calculate_price_and_expiry(payment, cost_before)
      cost_after = calculate_price(payment) * payment.months
      cost_to_pay = cost_after - cost_before
      payment.update(total_cost: cost_to_pay, expiry_date: payment.start_date.months_since(payment.months))
    end
=end


    def calculate_variance(plan_id = 1, mean, n)
      plan_months = Payment.joins(:plan_payments).where('plan_payments.plan_id' => plan_id).pluck(:months)
      sum = 0
      plan_months.each do |x|
        sum += ((x - mean) ** 2)
      end
      sum / (n-1)
    end

    def calculate_addon_variance(addon_id, mean, n)
      addon_months = Payment.joins(:add_on_payments).where('add_on_payments.add_on_id' => addon_id).pluck(:months)
      sum = 0
      addon_months.each do |x|
        sum += ((x - mean) ** 2)
      end
      sum / (n-1)
    end

    def get_max_months(plan_id = 1)
      max = Payment.joins(:plan_payments).where('plan_payments.plan_id' => plan_id).order(months: :desc).limit(1).pluck(:months).first
    end

    def get_addon_max_months(addon_id)
      max = Payment.joins(:add_on_payments).where('add_on_payments.add_on_id' => addon_id).order(months: :desc).limit(1).pluck(:months).first
    end

    def get_min_months(plan_id = 1)
      min = Payment.joins(:plan_payments).where('plan_payments.plan_id' => plan_id).order(months: :asc).limit(1).pluck(:months).first
    end

    def get_addon_min_months(addon_id)
      min = Payment.joins(:add_on_payments).where('add_on_payments.add_on_id' => addon_id).order(months: :asc).limit(1).pluck(:months).first
    end

    def calculate_price (payment)
      total_cost = 0
      deal_plan_cost = Plan.find(1).cost      # deal listing plan has id = 1
      add_on1_cost = AddOn.find(1).cost
      add_on2_cost = AddOn.find(2).cost
      add_on3_cost = AddOn.find(3).cost

      if payment.plan1
        total_cost = total_cost + deal_plan_cost
      end
      if payment.add_on1
        total_cost = total_cost + add_on1_cost
      end
      if payment.add_on2
        total_cost = total_cost + add_on2_cost
      end
      if payment.add_on3
        total_cost = total_cost + add_on3_cost
      end

      total_cost
    end

    def destroy(payment)
      Payment.destroy(payment.id)
    end


  end

  class << self
    include ClassMethods
  end
end
