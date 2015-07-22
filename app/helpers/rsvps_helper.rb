module RsvpsHelper

  def total_kids(rsvps)
    total = 0
    rsvps.each do |rsvp|
      total = total + rsvp.number_of_kids
    end
    total
  end

  def total_adults(rsvps)
    total = 0
    rsvps.each do |rsvp|
      total = total + rsvp.number_of_adults
    end
    total
  end

  def has_comments(rsvps)
    rsvps.each do |rsvp|
      return true if rsvp.comments.present?
    end
    false
  end

end
