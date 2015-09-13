class DealMailer < ActionMailer::Base
  default from: "burpple@mail.com"

  def deal_email(user, deal)
    @user = user
    @deal = deal
    @url = "www.example.com"
    mail(to: "woonyong92@gmail.com", subject: "Congratulations! You have successfully listed a deal on Burpple!")
  end

  def format_days (deal_day)
    deal_days = [deal_day.mon, deal_day.tue, deal_day.wed, deal_day.thur, deal_day.fri, deal_day.sat, deal_day.sun ]
    days = ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun']
    dealperiod = ""
    i = 0

    while i<7
      # For first day which is selected, no need to put comma
      if deal_days[i] && dealperiod == ""
        dealperiod = dealperiod + days[i]
        # If the string already contains thing, then need put comma
      elsif deal_days[i] && dealperiod != ""
        dealperiod = dealperiod + ", " + days[i]
      end

      # Inner while loop is to string consecutive days together if the current day is selected
      if deal_days[i]
        j = i + 1
        while j<7
          # If the day is not selected, break out of loop
          if !deal_days[j]
            break
          elsif j == 6 && deal_days[j]
            dealperiod = dealperiod + "-" + days[j]
            i = j+1
            break
          elsif j == 6 && !deal_days[j]
            i = j+1
            break
            # If the day is selected, and next one is selected, just continue
          elsif deal_days[j] && deal_days[j+1]
            j = j+1
            # If day is selected, and next one is not, place "- day" and break
          elsif deal_days[j] && !deal_days[j+1]
            dealperiod = dealperiod + "-" + days[j]
            i = j + 1
            break
          end
        end
      end
      i = i +1
    end
    dealperiod
  end
  helper_method :format_days
end
