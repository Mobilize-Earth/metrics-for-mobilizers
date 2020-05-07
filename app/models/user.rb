class User < ApplicationRecord
  belongs_to :chapter, optional: true
  validates :chapter, presence: true, if: :external_coordinator?
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable,
  # :rememberable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :recoverable, :validatable, :registerable
  attr_accessor :invitation_link, :skip_password_validation

  validates :first_name, :last_name, :phone_number, presence: true, on: :update
  validates :phone_number, numericality: {only_integer: true, :greater_than => 0}, on: :update
  validates :phone_number, format: { without: /(000000000)/, message: "invalid" }, on: :update
  validate :check_role_dashboard
  validates :email, :email => true
  validate :chapter_limit_of_two_users

  def check_role_dashboard
    if role != 'external' and chapter_id != nil then
      errors.add(:role, "should be external")
    end
  end

  def external_coordinator?
    self.role == "external" ? true : false
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def chapter_limit_of_two_users
    if !chapter.nil? && chapter.users.size >= 2
      errors.add(:chapter, :external_user_limit)
    end
  end

  protected
  def password_required?
    return false if skip_password_validation
    super
  end
end
