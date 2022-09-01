class Admin < ApplicationRecord
  after_commit :send_notification
  has_many :notifications, foreign_key: :recipient_id
  require "csv"
    include PgSearch::Model
     pg_search_scope :custom_search,
                  against: [:full_name, :email, :phone_number, :location, :status, :user_name],
                  using: {
                    tsearch: { prefix: true }
                  }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  scope :sub_admins, -> { where(admin_type: "sub_admin")}
  validates :full_name, :user_name, :phone_number, :location, :date_of_birth, presence: true
  
  

  enum admin_type: {
    admin: 0,
    sub_admin: 1,
  }

   def self.to_csv
      CSV.generate(headers: true) do |csv|
        csv << self.attribute_names
        all.each do |record|
          csv << record.attributes.values
        end
      end
      if csv_count = Setting.last.present?
        csv_count = Setting.last.csv_count
        Setting.update(csv_count:csv_count +1)
      else
        csv_count = Setting.create(csv_count: 1)
      end
   end

  def send_notification
    Admin.admin.each do |admin|
      Notification.create(recipient: admin, actor: admin,action: "#{admin.full_name} is active",notifiable: self)
    end
  end
end
