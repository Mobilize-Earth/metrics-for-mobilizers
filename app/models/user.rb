class User < ApplicationRecord
  belongs_to :chapter, optional: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :registerable,  :rememberable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :validatable
  attr_accessor :password_confirmation

  validates :first_name, :last_name, :phone_number, presence: true
  validate :check_role_dashboard
  validates :phone_number, format: { with: /\A\d+\z/, message: "can be digits only." }
  validates :email, :email => true

  def check_role_dashboard
    if role != 'external' and chapter_id != nil then
      errors.add(:role, "should be external")
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
