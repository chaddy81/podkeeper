module NotesHelper
  def show_note_notification(pod, note)
    if current_user.pod_memberships.find_by_pod_id(pod.id).last_visit_notes < note.created_at && note.user != current_user
      return true
    else
      return false
    end
  end

  def topic_counter(note, remaining_chars)
    if note.topic.blank?
      content_tag(:span, "60 / 60 characters", id: "topic-counter")
    else
      content = "#{ remaining_chars } / 60 characters"
      classes = ['counter']
      if remaining_chars.to_i < 0
        classes << 'red'
      end
      content_tag(:span, content, class: classes, id: "topic-counter")
    end
  end

  def details_counter(note, remaining_chars)
    if note.body.blank?
      content_tag(:span, "2000 / 2000 characters", id: "details-counter")
    else
      content = "#{ remaining_chars } / 2000 characters"
      classes = ['counter']
      if remaining_chars.to_i < 0
        classes << 'red'
      end
      content_tag(:span, content, class: classes, id: "details-counter")
    end
  end

end
