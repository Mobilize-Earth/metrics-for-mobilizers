class User < ApplicationRecord
  belongs_to :chapter, optional: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :registerable,  :rememberable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :validatable
  attr_accessor :password_confirmation

  validates :first_name, :last_name, :password_confirmation, :phone_number, presence: true
  validates :email, :email => true

  def full_name
    "#{first_name} #{last_name}"
  end
end
