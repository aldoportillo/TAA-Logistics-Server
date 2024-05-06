class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  phony_normalize :phone_number, default_country_code: 'US'
  validates :phone_number, phony_plausible: true, presence: true

  # Check user roles
  def admin?
    role == 'admin'
  end

  def hiring?
    role == 'hiring'
  end

  def broker?
    role == 'broker'
  end

  def driver?
    role == 'driver'
  end
end
