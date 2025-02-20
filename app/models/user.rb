class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :phone_number, presence: true

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
