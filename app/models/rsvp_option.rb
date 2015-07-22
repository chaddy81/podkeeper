class RsvpOption < ActiveRecord::Base
  attr_accessible :color, :display_name, :name

  has_many :rsvps

  def self.yes
    RsvpOption.find_by_name('yes')
  end

  def self.no
    RsvpOption.find_by_name('no')
  end

  def self.maybe
    RsvpOption.find_by_name('maybe')
  end

end
