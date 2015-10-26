require 'prawn/qrcode'

class QrcodePdf < Prawn::Document
  def initialize (deal)
    super()
    @deal = deal
    @deal.venues.each_with_index do |venue, index|
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
    text "#{@deal.title} at #{venue.name}", size: 20, style: :bold, align: :center
  end
  
  def dates
    move_down 10
    text "From #{@deal.start_date.strftime("%d/%m/%Y")} to #{@deal.expiry_date.strftime("%d/%m/%Y")}", size: 16, style: :bold, align: :center, top_margin: 18

    for deal_day in @deal.deal_days
      str = ""
      str = str + DealService.format_days(deal_day) + ':'
      for deal_time in deal_day.deal_times
        str = str + " " + deal_time.started_at.strftime("%H:%M") + ' to ' + deal_time.ended_at.strftime("%H:%M")
      end
      text "#{str}", size: 16, style: :bold, align: :center
    end
  end


  def multiple_use
    move_down 10
    if @deal.multiple_use
      text "Unlimited Redeems!", size: 16, style: :bold, align: :center
    else
      text "Limited to one Redeem per Customer", size: 16, style: :bold, align: :center
    end
  end

  def qr_code(venue)
    print_qr_code(@deal.id.to_s + "_" + venue.id.to_s + "_" + @deal.created_at.to_s, extent: 400, stroke: false, align: :center)
  end

  def instructions(venue)
    text "Instructions to redeem deal:", size: 16, align: :center
    text "1) Download Burpple App", size: 12, align: :center
    text "2) Search for #{venue.name}", size: 12, align: :center
    text "3) Go to the deals section", size: 12, align: :center
    text "4) Select the deal", size: 12, align: :center
    text "5) Press Redeem", size: 12, align: :center
    text "6) Scan the QR Code", size: 12, align: :center
  end
end