class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :registerable, , :rememberable :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :validatable
end
