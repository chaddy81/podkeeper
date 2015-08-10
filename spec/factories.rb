FactoryGirl.define do

  factory :access_level do
    name 'pod_admin'
    display_name 'Pod Admin'
  end

  factory :comment do
    body 'This is the comment body'
    user
    note
  end

  factory :deleted_pod_attribute do
    creator_first_name         'John'
    creator_last_name          'Smith'
    number_of_pod_admins       4
    number_of_members          6
    number_of_open_invites     10
    number_of_discussions      12
    number_of_comments         33
    number_of_upcoming_events  2
    number_of_past_events      1
    number_of_task_lists       3
    number_of_tasks            1
    number_of_documents        0
    pod_name                   'Soccer Pod'
    association :deleter, factory: :user
    association :creator, factory: :user
  end

  factory :event do
    sequence(:name) { |n| "#{n}Park Picnic" }
    description  'A Sunday afternoon picnic'
    location     'City Park'
    start_date   Date.tomorrow
    start_time   4321.minutes.from_now
    require_rsvp true
    completed    false
    confirmed    true
    pod
    association :organizer, factory: :user
  end

  factory :event_note do
    note 'This is a note that will be sent to some members'
    event_id 1
  end

  factory :event_reminder do
    days_before 4
    event
  end

  factory :invite_request do
    sequence(:email) { |n| "invite_request_email#{n}@podkeeper.com" }
    first_name 'Derek'
    last_name  'Harrington'
  end

  factory :invalid_email do
    email 'invalid'
    pod
    user
  end

  factory :site_invite, class: 'Invite' do
    sequence(:email) { |e| "invite_email#{e}@podkeeper.com" }
    first_name 'John'
    last_name  'Smith'
    association :inviter, factory: :user
    pod_name   'Baseball'
  end

  factory :pod_invite, class: 'Invite' do
    sequence(:email) { |e| "pod_invite_email#{e}@podkeeper.com" }
    first_name 'John'
    last_name  'Smith'
    association :inviter, factory: :user
    pod
  end

  factory :kid do
    name 'Johnny'
    user
    pod
  end

  factory :list do
    name        'End of the year party'
    details     'Sign up to bring something'
    association :creator, factory: :user
    list_type
  end

  factory :list_item do
    list
    item 'cookies'
  end

  factory :list_type do
    name         'list'
    display_name 'List Type'
  end

  factory :note do
    topic 'Troop Meeting'
    body  'Make sure to remember your books.'
    user
    pod
  end

  factory :pod_category do
    name         'programming'
    display_name 'Programming'
  end

  factory :pod_membership do
    access_level
    user
    pod
    last_visit_notes DateTime.now - 1.week
  end

  factory :pod_sub_category do
    name         'ruby'
    display_name 'Ruby'
    pod_category
  end

  factory :pod_user do
    first_name 'Chris'
    last_name  'Schmitz'
    sequence(:email) { |e| "pod_user_email#{e}@podkeeper.com" }
    password  'password'
    password_confirmation 'password'
    name        'Boy Scouts'
    description 'A pod to organize stuff'
    pod_category
  end

  factory :pod do
    name        'Soccer Team'
    description 'An area to manage our local youth soccer team'
    pod_category
    association :organizer, factory: :user
  end

  factory :reminder do
    association :invite, factory: :site_invite
  end

  factory :rsvp_option do
    name         'yes'
    display_name 'Yes'
    color        'green'
  end

  factory :rsvp_reminder do
    days_before 4
    event
  end

  factory :rsvp do
    number_of_kids   2
    number_of_adults 2
    comments         'Cant wait to see everybody there'
    user
    event
    rsvp_option
  end

  factory :setting do
    pod
    user
  end

  factory :site_comment do
    body 'I wish you would add a feature for recurring events'
    user
  end

  factory :uploaded_file do
    url 'http://entrision.com/assets/logo.png'
    description 'soccer picture'
    pod_membership
  end

  factory :user do
    sequence(:email) { |n| "user_email#{n}@podkeeper.com" }
    first_name 'Janet'
    last_name  'Johnson'
    password   'password'
    password_confirmation 'password'
    time_zone 'Central Time (US & Canada)'
  end

  factory :email, class: OpenStruct do
    # Assumes Griddler.configure.to is :hash (default)
    to [{ full: 'discussion-abc123@email.com', email: 'discussion-abc123@email.com', token: 'discussion-abc123', host: 'email.com', name: nil }]
    from 'from_email@email.com'
    subject 'Discussion - Pod Name'
    body 'Hello!'
  end

end
