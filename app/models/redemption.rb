class Redemption < ActiveRecord::Base
  include Redemption::Json

  belongs_to :deal
  belongs_to :user

  def self.save(user_id,deal_id,venue_id)
    redemption = Redemption.new
    redemption.user_id = user_id
    redemption.deal_id = deal_id
    redemption.venue_id = venue_id
    redemption.save

    return redemption

  end

  def valid_time
    valid = true # flag
    day_valid = false #flag
    hour_valid = false #flag

    deal = self.deal
    deal_days = deal.deal_days

    time = Time.new
    day = time.day
    hour = time.hour

    deal_days.each { |deal_day|
      unless day_valid && hour_valid # escape out of loop if day and hour is valid
        # check against the deal_day
        day_valid = deal_day.check_day day

        #check hour only if day is valid
        if day_valid
          deal_times = deal_day.deal_times

          # check against the deal_day's deal_times
          deal_times.each { |deal_time|
            unless hour_valid #escape out of loop if hour is valid
              hour_valid = deal_time.valid_hour hour
            end
          }
        end

      end
    }
    return day_valid && hour_valid
  end
end

