class PaymentService

  module ClassMethods

    def get_overlapping_payments(merchant_id, new_start_date)
      all_payments = Payment.where(:merchant_id => merchant_id)
      valid_payments = all_payments.where('expiry_date >= ? AND paid = ? AND plan1 = ?', DateTime.now, true, true)
      overlapping_payments = valid_payments.where('expiry_date >= ?', new_start_date)
      overlapping_payments.count
    end
  end

  class << self
    include ClassMethods
  end
end
