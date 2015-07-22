class PodUser < ActiveRecord::Base
  has_no_table

  attr_accessible :password, :password_confirmation, :pod_category_id, :pod_category, :pod_sub_category_id, :pod_sub_category,
                :description, :invites_attributes, :name, :first_name, :last_name, :email, :password, :phone,
                :remember_me, :time_zone, :invite_id

  attr_accessor :testing_name, :testing_pod_category, :testing_first_name, :testing_last_name

  column :first_name
  column :last_name
  column :phone
  column :email
  column :time_zone
  column :remember_me
  column :password

  column :name
  column :description
  column :pod_category_id
  column :pod_sub_category_id

  column :invite_id

  belongs_to :pod_category
  belongs_to :pod_sub_category

  validates :name, presence: true, if: :test_name?
  validates :pod_category_id, presence: true, if: :test_pod_category?
  validates :pod_sub_category_id, presence: true, if: :validate_sub_category?

  validates :first_name, presence: true, if: :test_first_name?
  validates :last_name,  presence: true, if: :test_last_name?
  validates :phone,      length: { is: 12, message: 'is the wrong length (should be 10 digits)' }, allow_blank: true
  validates :email,      presence: true,
                         format:   { with: VALID_EMAIL_REGEX }

  validate :email_is_unique
  validates :password, presence: true, length: { minimum: 6, maximum: 128 }

  private
  def test_name?
    return true unless testing_name == false
  end

  def test_pod_category?
    return true unless testing_pod_category == false
  end

  def test_first_name?
    return true unless testing_first_name == false
  end

  def test_last_name?
    return true unless testing_last_name == false
  end

  def validate_sub_category?
    return false if self.pod_category.nil?
    pod_category.name == 'sports' || pod_category.name == 'arts_music' || pod_category.name == 'parents_activity'
  end

  def email_is_unique
    if User.find_by_email(self.email.downcase)
      errors.add(:email, 'has already been taken. Perhaps you’ve previously joined. <a href="/">Sign In</a>')
      false
    end
  end

end
