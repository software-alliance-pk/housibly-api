class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  scope :sub_admins, -> { where(admin_type: "sub_admin")}

  enum admin_type: {
    admin: 0,
    sub_admin: 1,
  }
end
