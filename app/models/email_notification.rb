class EmailNotification < ActiveRecord::Base
  attr_accessible :email, :timestamp, :ip, :sg_message_id, :sg_event_id, :useragent, :event, :ip, :url
end
