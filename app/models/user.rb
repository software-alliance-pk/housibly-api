class User < ApplicationRecord
  require 'csv'
  include PgSearch::Model
     pg_search_scope :custom_search,
                  against: [:full_name, :email, :phone_number],
                  associated_against: {
                  professions: :title},
                  using: {
                    tsearch: { prefix: true }
                  }
  has_secure_password
  has_many :mobile_devices
  has_many :conversations, dependent: :destroy,foreign_key: :sender_id
  has_many :conversations, dependent: :destroy,foreign_key: :recipient_id
  has_many :support_conversations, dependent: :destroy,foreign_key: :sender_id
  has_many :support_conversations, dependent: :destroy,foreign_key: :recipient_id
  has_many :messages, dependent: :destroy
  has_many :support_messages, dependent: :destroy
  geocoded_by :address
  has_many :notifications, foreign_key: :recipient_id, class_name: "Notification"
  has_many :notifications, foreign_key: :actor_id, class_name: 'Notification'
  has_many :support_closer_reviews, class_name: "Review",dependent: :destroy,foreign_key: :support_closer_id
  has_many :reportings, dependent: :destroy, foreign_key: :user_id
  has_many :user_reports, class_name: "Reporting", dependent: :destroy, foreign_key: :reported_user_id
  has_many :reviews,dependent: :destroy,foreign_key: :user_id
  has_many :view_visitor, class_name: "Visitor",dependent: :destroy,foreign_key: :visit_id
  has_many :visitor,dependent: :destroy,foreign_key: :user_id
  after_validation :geocode, :if => :address_changed?
  has_many_attached :images, dependent: :destroy
  has_many_attached :certificates,  dependent: :destroy
  has_many :professions,  dependent: :destroy
  has_one :schedule,  dependent: :destroy
  has_many :bookmarks,  dependent: :destroy
  has_one_attached :avatar,  dependent: :destroy
  has_one :user_preference, dependent: :destroy
  has_many :dream_addresses, dependent: :destroy
  has_many :properties, dependent: :destroy
  has_many :supports, dependent: :destroy
  has_many :card_infos, dependent: :destroy
  accepts_nested_attributes_for :professions, :schedule

  validates :full_name, :email, :phone_number, :user_type,
            :profile_type, :password_digest, presence: true
  validates_inclusion_of :contacted_by_real_estate, :licensed_realtor, in: [true, false]
  validates :phone_number, format: { with: /\A^\+?\d+$\z/ }
  validates :phone_number, uniqueness: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :password_digest, length: { minimum: 6 }, confirmation: true
  validates :user_type, inclusion: { in: %w(seller buyer neither) }

  enum property_type: [:house, :condo, :vacant_land]
  enum user_type: {
    seller: 0,
    buyer: 1,
    neither: 2
  }
  enum profile_type: {
    want_sell: 0,
    want_buy: 1,
    want_support_closer: 2
  }

  scope :get_support_closer_user,-> { want_support_closer.order(created_at: :desc)}
  scope :get_all_buyer,-> { want_buy.order(created_at: :desc)}
  scope :get_all_seller,-> { want_sell.order(created_at: :desc)}
  scope :get_new_user,-> { order(created_at: :desc)}
  scope :count_active_user, -> { where('active = (?)',true) }
  scope :count_support_closer_user, -> { want_support_closer.count }
  scope :all_users, -> { where.not(profile_type: "want_support_closer")}
  scope :new_users, -> { where('created_at >= :five_days_ago', :five_days_ago => 5.days.ago) }
  def generate_password_token!
    self.reset_password_token = generate_otp
    self.reset_password_sent_at = Time.now.utc
    self.save!
  end

  def password_token_valid?
    (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end

  def generate_signup_token!
    self.reset_signup_token = generate_otp
    self.reset_signup_token_sent_at = Time.now.utc
    self.save!
  end

  def signup_token_valid?
    (self.reset_signup_token_sent_at + 4.hours) > Time.now.utc
  end

  def reset_password!(password)
    self.reset_signup_token = nil
    self.password = password
    self.save!
  end
  private

  def generate_otp
    otp_length(6)
  end

  def otp_length(length)
    rand((9.to_s * length).to_i).to_s.center(length, rand(9).to_s).to_i
  end


      

  def self.to_csv
       CSV.generate(headers: true) do |csv|
        csv << self.attribute_names
        all.each do |record|
          csv << record.attributes.values_at(*attribute_names)
      end
    end
  end
      # def test
      #   if csv_count = Setting.last.present?
      #     csv_count = Setting.last.csv_count
      #     Setting.update(csv_count:csv_count +1)
      #   else
      #     csv_count = Setting.create(csv_count: 1)
      #   end
      # end
  


end
