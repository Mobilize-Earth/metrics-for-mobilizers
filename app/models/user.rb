class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :registerable, :recoverable, :rememberable, :trackable and :omniauthable
  devise :database_authenticatable, :validatable

  validates :email, presence: true, :email => true
end
