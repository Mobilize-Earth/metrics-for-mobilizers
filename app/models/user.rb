class User < ApplicationRecord
  belongs_to :chapter, optional: true
  validates :chapter, presence: true, if: :external_coordinator?
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :registerable,
  # :rememberable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :validatable
  attr_accessor :password_confirmation

  validates :first_name, :last_name, :phone_number, presence: true
  validate :check_role_dashboard
  validates :phone_number, numericality: {only_integer: true, :greater_than_or_equal_to => 0}
  validates :phone_number, format: { without: /(000000000)/,
                                                   message: "invalid" }
  validates :email, :email => true

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
end
