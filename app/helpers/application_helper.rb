module ApplicationHelper

  def full_title(page_title)
    base_title = "PodKeeper"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}".html_safe
    end
  end

  def page_description(description)
    default_desc = "Keep your family and groups organized in one place for free. Moms, dads, volunteers and coaches use our easy scheduling software to manage a school class, scout troop, sports team."
    if description.empty?
      default_desc
    else
      "#{description}".html_safe
    end
  end

  def yes_or_no(val)
  	if val
      'Yes'
    else
      'No'
    end
  end

  def pretty_date_time(date)
    l date.in_time_zone, format: '%B %e, %Y at %I:%M%p %Z'
  end

  def pretty_date(date)
    l date.in_time_zone, format: '%m/%d/%Y'
  end

  def pretty_time(time)
    l time.in_time_zone, format: '%I:%M %p %Z'
  end

  def timepicker_format(time)
    return "" if time.nil?
    "#{l time, format: '%I:%M'} #{(l time, format: '%P').upcase }"
  end

  def datepicker_format(date)
    return "" if date.nil?
    "#{l date, format: '%m/%d/%Y'}"
  end

  def event_date_time(event, user)
    time_zone = user.class.to_s == 'User' ? user.time_zone : event.time_zone
    "#{l event.start_date, format: '%a. %b %e'}, #{l event.start_time.in_time_zone(time_zone), format: '%I:%M%p %Z'}"
  end

  def event_end_date_time(event)
    if event.end_time.present?
      "#{l event.end_date, format: '%a %b %e'}, #{l event.end_time, format: '%I:%M%p %Z'}"
    end
  end

  def google_map_link(address)
    "http://maps.google.com/?q=#{address}"
  end

  def pod_organizer(pod)
    mailto = "mailto:#{pod.organizer.email}"
    "#{pod.organizer.full_name}, #{link_to pod.organizer.email, mailto, target: '_blank'} #{',' unless pod.organizer.phone.blank?} #{pod.organizer.phone}".html_safe
  end

  def sort_direction(column=nil)
    direction = params[:direction] || 'asc'
    if column.present? && column == params[:column]
      direction == 'asc' ? 'desc' : 'asc'
    else
      # direction
      'desc'
    end
  end

  def inverse_sort_direction(column=nil)
    sort_direction(column) == 'asc' ? 'desc' : 'asc'
  end

  def invite_count
    current_user.received_invites.unaccepted.where('pod_id IS NOT NULL').count
  end

  def last_pod_by_slug
    pod = Pod.where(id: current_user.last_pod_visited_id).first
    pod.slug
  end

  def bootstrap_class_for flash_type
    case flash_type
      when :success
        "alert-success"
      when :error
        "alert-danger"
      when :alert
        "alert-warning"
      when :notice
        "alert-info"
      when :warning
        "alert-warning"
      else
        flash_type.to_s
    end
  end

  def get_icon category, subcategory=nil
    unless subcategory.nil?
      POD_ICONS[category.to_s][subcategory.to_s]
    else
      POD_ICONS[category.to_s]
    end
  end

  def event_calendar_title
    ->(start_date) { content_tag :span, "#{I18n.t("date.month_names")[start_date.month]} #{start_date.year}", class: "event-calendar__month" }
  end

  def events_ajax_previous_link
    ->(param, date_range) {
      link_to events_path({param => date_range.first - 1.day}), class: 'event-calendar__prev', remote: :true do
        "<svg class='icon center-block' viewbox='0 0 1024 1024'><use xlink:href='#icon-podkeeper-arrow-left'></use></svg>".html_safe
      end
    }
  end

  def events_ajax_next_link
    ->(param, date_range) {
      link_to events_path({param => date_range.last + 1.day}), class: 'event-calendar__next', remote: :true do
        "<svg class='icon center-block' viewbox='0 0 1024 1024'><use xlink:href='#icon-podkeeper-arrow-right'></use></svg>".html_safe
      end
    }
  end

  def is_active?(test_path)
    return 'active' if request.path == test_path
    ''
  end

  def get_gravatar(email, size)
    digest = Digest::MD5.hexdigest(email)
    return "http://www.gravatar.com/avatar/" + digest + ".jpg?s=#{size}"
  end

end
