require 'rest-client'

class GoogleAnalyticsApi

  def send_event(category, action, label, client_id = '555')
    return unless GOOGLE_ANALYTICS_SETTINGS[:tracking_code].present?

    params = {
      v: GOOGLE_ANALYTICS_SETTINGS[:version],
      tid: GOOGLE_ANALYTICS_SETTINGS[:tracking_code],
      cid: client_id,
      t: "event",
      ec: category,
      ea: action,
      el: label
    }

    begin
      RestClient.get(GOOGLE_ANALYTICS_SETTINGS[:endpoint], params: params, timeout: 4, open_timeout: 4)
      return true
    rescue  RestClient::Exception => rex
      return false
    end
  end

  def send_page_view(page, title, client_id = '555')
    return unless GOOGLE_ANALYTICS_SETTINGS[:tracking_code].present?

    params = {
      v: GOOGLE_ANALYTICS_SETTINGS[:version],
      tid: GOOGLE_ANALYTICS_SETTINGS[:tracking_code],
      cid: client_id,
      t: "pageview",
      dh: "podkeeper.com",
      dp: page,
      dt: title
    }

    begin
      RestClient.get(GOOGLE_ANALYTICS_SETTINGS[:endpoint], params: params, timeout: 4, open_timeout: 4)
      return true
    rescue  RestClient::Exception => rex
      return false
    end
  end

end
