class Admin < ApplicationRecord
  #after_commit :send_notification
  include CsvCounter
  has_many :pages, dependent: :destroy
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy
  has_many :support_conversations, dependent: :destroy,foreign_key: :recipient_id
  has_many :admin_support_messages, dependent: :destroy,foreign_key: :sender_id
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
     CsvCounter.update_csv_counter
     CSV.generate(headers: true) do |csv|
       csv << self.attribute_names
       all.each do |record|
         csv << record.attributes.values
       end
     end
   end

  # def send_notification
  #   Admin.admin.each do |admin|
  #     Notification.create(recipient: admin, actor: admin,action: "#{admin.full_name} is active",notifiable: self)
  #   end
  # end
end
