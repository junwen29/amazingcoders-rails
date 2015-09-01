class Biz::MarketingController < Biz::ApplicationController
  before_filter :set_title, :set_stylesheet
  before_filter :authenticate_merchant!, except: [:index, :features, :inbound_marketing] 

  def index
  #  @viewport = "desktop"
  end

  def features
    @viewport = "desktop"
  end

  def inbound_marketing
    @viewport = "desktop"
  end

  # business pdf download
  def pdf
    merchant_id = params[:m_id]
    referrer    = params[:ref]
    event_name  = "Downloaded Business PDF"
    Event.create(user_id: merchant_id, user_type: Merchant.name, name: event_name, properties: { referrer: referrer })
    biz_track_event event_name, { distinct_id: merchant_id, "#{event_name.downcase.gsub(' ','_')}.referrer" => referrer }
    redirect_to "http://s3.burpple.com/biz/burpple_business.pdf"
  end

  private

    def set_title
      @html_title = "Burpple for Business"
    end

    def set_stylesheet
      @application_stylesheet = "biz/marketing"
    end
end
