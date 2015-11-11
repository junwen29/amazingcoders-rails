require 'prawn/qrcode'

class QrcodePdf < Prawn::Document
  def initialize (deal)
    super()
    @deal = deal
    logo = "#{Rails.root}/app/assets/images/biz/burpple_image_logo.jpg"
    @deal.venues.each_with_index do |venue, index|
      stroke_color "ea1f6c"
      stroke do
        line(bounds.bottom_left, bounds.bottom_right)
        line(bounds.bottom_right, bounds.top_right)
        line(bounds.top_right, bounds.top_left)
        line(bounds.top_left, bounds.bottom_left)
      end
      move_down 10
      image logo, width: 500, height: 75, position: :center
      title(venue)
      dates
      multiple_use
      qr_code(venue)
      instructions(venue)
      if index != @deal.venues.size - 1
        start_new_page
      end
    end
  end

  def title(venue)
    move_down 10
    span(480, :position => :center) do
      text "#{@deal.title}", size: 15, style: :bold, align: :center
      text "at", size: 15, style: :bold, align: :center
      text "#{venue.name}", size: 15, style: :bold, align: :center
    end
  end

  def dates
    move_down 10
    text "From #{@deal.start_date.strftime("%d/%m/%Y")} to #{@deal.expiry_date.strftime("%d/%m/%Y")}", size: 14, style: :bold, align: :center, top_margin: 18

    for deal_day in @deal.deal_days
      str = ""
      str = str + DealService.format_days(deal_day) + ':'
      for deal_time in deal_day.deal_times
        str = str + " " + deal_time.started_at.strftime("%H:%M") + ' to ' + deal_time.ended_at.strftime("%H:%M")
      end
      text "#{str}", size: 12, style: :bold, align: :center
    end
  end


  def multiple_use
    move_down 10
    if @deal.multiple_use
      text "Unlimited Redeems!", size: 12, style: :bold, align: :center
    else
      text "Limited to one Redeem per Customer", size: 12, style: :bold, align: :center
    end
  end

  def qr_code(venue)
    print_qr_code(@deal.id.to_s + "_" + venue.id.to_s + "_" + @deal.created_at.to_s, extent: 400, stroke: false, align: :center)
  end

  def instructions(venue)
    text "Instructions to redeem deal:", size: 14, align: :center
    text "1) Download Burpple App", size: 12, align: :center
    text "2) Sign up or Log In", size: 12, align: :center
    text "3) Press Camera Icon and Scan QrCode", size: 12, align: :center
    text "4) Show Redeem Page to Staff and Enjoy!", size: 12, align: :center
  end
end