class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :registerable,  :rememberable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :validatable

  validates :email, presence: true, :email => true


  class Rol < ActiveRecord::Base
    enum rol: { admin: 0, external_coordinator: 1, other_data_consumer: 2 }
  end
end
