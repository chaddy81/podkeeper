class AccessLevel < ActiveRecord::Base
  attr_accessible :display_name, :name

  has_many :pod_memberships

  def self.pod_admin_with_sharing
    AccessLevel.find_by_name('pod_admin_with_grant_option')
  end

  def self.pod_admin
    AccessLevel.find_by_name('pod_admin')
  end

  def self.member
    AccessLevel.find_by_name('member')
  end

end
