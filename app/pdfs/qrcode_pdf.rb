require 'prawn/qrcode'

class QrcodePdf < Prawn::Document
  def initialize (deal)
    super()
    @deal = deal
    @deal.venues.each_with_index do |venue, index|
      title
      dates
      venue_name(venue)
      qr_code(venue)
      instructions(venue)
      if index != @deal.venues.size - 1
        start_new_page
      end
    end
  end

  def title
    text "Title of deal: #{@deal.title}", size: 20, style: :bold, align: :center
  end
  
  def dates
    move_down 20
    text "Deal Period:#{@deal.start_date.strftime("%d/%m/%Y")} to #{@deal.expiry_date.strftime("%d/%m/%Y")}", size: 16, style: :bold, align: :center, top_margin: 20

    for deal_day in @deal.deal_days
      text "#{DealService.format_days (deal_day)}", size: 16, style: :bold, align: :center
    end
    for deal_time in deal_day.deal_times
      text "#{deal_time.started_at.strftime("%H:%M")} to #{deal_time.ended_at.strftime("%H:%M")}", size: 16, style: :bold, align: :center
    end
  end

  def venue_name(venue)
    move_down 20
    text "QR Code for: #{venue.name}", align: :center, size: 16, style: :bold
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