class ListDecorator < ApplicationDecorator
  delegate_all
  decorates :list

  def created_at
    h.content_tag(:small, object.created_at.strftime('%a, %b %d, %Y, %I:%M %P'))
  end

  def details
    h.content_tag(:small, h.simple_format(object.details))
  end

  def display_name
    object.list_type.display_name
  end

  def author
    object.creator.try(:full_name)
  end

  def edit_link
    if h.current_user?(object.creator) || is_at_least_pod_admin?
      h.link_to edit_path do
        h.content_tag(:svg, h.content_tag(:use, "", { "xlink:href" => '#icon-podkeeper-edit' }), class: "icon icon-edit", style: "margin: 0 5px;width: 16px;height: 16px;" )
      end
    end
  end

  def delete_link
    if h.current_user?(object.creator) || is_at_least_pod_admin?
      h.link_to list_path, id: "delete_list_#{object.id}", class: 'delete', method: :delete, data: { confirm: 'Are you sure you want to delete this list? All list items will also be deleted.' } do
        h.content_tag(:svg, h.content_tag(:use, "", { "xlink:href" => '#icon-podkeeper-no' }), class: "icon icon-edit", style: "margin: 0 5px;width: 16px;height: 16px;" )
      end
    end
  end

  def notify_list
    if h.current_user?(object.creator) && !object.notification_has_been_sent?
      h.content_tag :p do
        h.concat("Once you fill out the List, have an email sent out: ")
        h.concat(h.link_to 'Notify the Pod of this List', notify_pod_list_path)
        h.concat(h.content_tag(:svg, h.content_tag(:use, "", { "xlink:href" => '#icon-podkeeper-info-yellow' }), class: 'icon', style: "width: 21px; height: 21px; margin-left: 10px;vertical-align: middle;", 'data-toggle' => "tooltip", 'data-placement' => "auto", 'data-html' => "true", title: "When you click this link, an email will be sent to all Pod members and invitees" ))
      end
    end
  end

  private

  def edit_path
    h.edit_list_path(self)
  end

  def list_path
    h.list_path(self)
  end

  def notify_pod_list_path
    h.notify_pod_list_path(self)
  end
end
