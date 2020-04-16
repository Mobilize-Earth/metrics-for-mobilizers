class User < ApplicationRecord
  belongs_to :chapter, optional: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :registerable,  :rememberable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :validatable

  validates :email, presence: true, :email => true

  class Rol < ActiveRecord::Base
    enum rol: { admin: 'admin', external_coordinator: 'external', other_data_consumer: 'consumer' }
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
