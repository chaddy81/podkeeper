module EventsHelper

  def show_event_notification(pod, event)
    if current_user.pod_memberships.find_by_pod_id(pod.id).last_visit_events < event.created_at && event.organizer != current_user
      return true
    else
      return false
    end
  end

  def my_rsvp(event)
    rsvp = current_user.rsvps.where(event_id: event.id).last
    rsvp || event.rsvps.new(number_of_adults: 0, number_of_kids: 0)
  end

  def rsvp_message(name)
    case name
    when "yes"
      return "I'll be there!"
    when "no"
      return "Can't Make It"
    when "maybe"
      return "Maybe"
    end
  end

  def calendar_format_start_date_time(event)
    "#{l event.start_date, format: '%Y%m%d'}T#{l event.start_time.in_time_zone, format: '%H%M%S'}"
  end

  def calendar_format_end_date_time(event)
    if event.end_date.nil?
      "#{l event.start_date, format: '%Y%m%d'}T#{l event.start_time.in_time_zone, format: '%H%M%S'}"
    else
      "#{l event.end_date, format: '%Y%m%d'}T#{l event.end_time.in_time_zone, format: '%H%M%S'}"
    end
  end

  def export_to_yahoo_link(event)
    "http://calendar.yahoo.com/?v=60&TITLE=#{CGI::escape event.name}&ST=#{calendar_format_start_date_time(event)}&ET=#{calendar_format_end_date_time(event)}&in_loc=#{CGI::escape event.location}#{' - ' unless event.address.blank?}#{CGI::escape event.address}&in_st#{CGI::escape event.street}&in_csz=#{CGI::escape event.city} #{CGI::escape event.state} #{event.zipcode}&desc=#{CGI::escape event.description}&URL=#{events_url(event.pod)}"
  end

  def export_to_google_calendar_link(event)
    "https://www.google.com/calendar/render?action=TEMPLATE&text=#{CGI::escape event.name }&dates=#{calendar_format_start_date_time(event)}/#{calendar_format_end_date_time(event)}&sprop=website:www.podkeeper.com&sprop=name:PodKeeper&location=#{CGI::escape event.location}#{' - ' unless event.address.blank?}#{CGI::escape event.address}&details=#{CGI::escape event.description}&sf=true&output=xml"
  end

  def otag_class(event)
    if event.confirmed_at > 3.days.ago && event.completed == false
      'otag otag-new'
    elsif event.updated_at > 3.days.ago && event.completed == false
      'otag otag-updated'
    end
  end

  def archive_view
    params[:completed] || 'false'
  end

  def rsvps_comments(rsvp_list, count_class)
    count = count_class == 'yes' ? rsvp_list.map{ |rsvp| rsvp.number_of_adults + rsvp.number_of_kids }.sum : rsvp_list.count
    text = ""
    rsvp_list.each do |rsvp|
      text << content_tag(:b, rsvp.user.full_name)
      text << content_tag(:br)
      text << rsvp.comments if rsvp.comments
    end


    i_tag = content_tag(:i, class: count_class) { count.to_s.html_safe }
    comments_tag = content_tag(:div, class: '') { text.html_safe }
    i_tag.html_safe + comments_tag.html_safe

  end

end
