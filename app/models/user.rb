class User < ApplicationRecord
  require 'csv'
  include CsvCounter
  include PgSearch::Model

  after_create :create_user_preference

  pg_search_scope :custom_search,
                  against: [:full_name, :email, :phone_number],
                  associated_against: { professions: :title },
                  using: { tsearch: { prefix: true } }

  acts_as_mappable :default_units => :kms,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  has_secure_password

  has_one_attached :avatar, dependent: :destroy
  has_many_attached :images, dependent: :destroy
  has_many_attached :certificates, dependent: :destroy

  has_one :user_preference, dependent: :destroy
  has_one :schedule, dependent: :destroy
  has_one :subscription, dependent: :destroy
  has_one :user_setting, dependent: :destroy

  has_many :professions, dependent: :destroy
  has_many :properties, dependent: :destroy
  has_many :dream_addresses, dependent: :destroy
  has_many :saved_searches, dependent: :destroy
  has_many :supports, dependent: :destroy
  has_many :card_infos, dependent: :destroy
  has_many :subscription_histories, dependent: :destroy
  has_many :mobile_devices, dependent: :destroy

  has_many :conversations, dependent: :destroy, foreign_key: :sender_id
  has_many :conversations, dependent: :destroy, foreign_key: :recipient_id
  has_many :support_conversations, dependent: :destroy, foreign_key: :sender_id
  has_many :support_conversations, dependent: :destroy, foreign_key: :recipient_id

  has_many :messages, dependent: :destroy
  has_many :user_support_messages, dependent: :destroy, foreign_key: :sender_id

  has_many :notifications_received, foreign_key: :recipient_id, class_name: 'Notification', dependent: :destroy
  has_many :notifications_sent, foreign_key: :actor_id, class_name: 'Notification', dependent: :destroy

  has_many :reportings, dependent: :destroy, foreign_key: :user_id
  has_many :user_reports, class_name: 'Reporting', dependent: :destroy, foreign_key: :reported_user_id

  has_many :user_search_addresses, dependent: :destroy
	has_many :searched_addresses, through: :user_search_addresses

  has_many :bookmarks, dependent: :destroy
  has_many :property_bookmarks
  has_many :user_bookmarks
  has_many :bookmarkings_by_users, class_name: 'UserBookmark', foreign_key: :bookmarked_user_id, dependent: :destroy

  has_many :reviews, dependent: :destroy # for regular users, reviews given to support closers
  has_many :support_closer_reviews, class_name: 'Review', dependent: :destroy, foreign_key: :support_closer_id # for support closers, reviews given by regular users

  has_many :visitors, dependent: :destroy # visits made by other users
  has_many :visits, class_name: 'Visitor', dependent: :destroy, foreign_key: :visit_id # visits made to other user profiles

  accepts_nested_attributes_for :professions, allow_destroy: true
  accepts_nested_attributes_for :schedule, :mobile_devices

  enum property_type: [:house, :condo, :vacant_land]
  enum user_type: {
    seller: 0,
    buyer: 1,
    neither: 2
  }
  enum profile_type: {
    want_sell: 0,
    want_buy: 1,
    support_closer: 2
  }

  validates :phone_number, presence: true, unless: -> { login_type == 'social_login' }
  validates :phone_number, uniqueness: true, if: -> { phone_number.present? }
  validates :phone_number, format: { with: /\A^\+?\d+$\z/ }, if: -> { phone_number.present? }

  validates_presence_of :full_name, :email, :password_digest
  validates_inclusion_of :contacted_by_real_estate, :licensed_realtor, in: [true, false]
  validates :email, uniqueness: { case_sensitive: false }
  validates :password_digest, length: { minimum: 6 }, confirmation: true
  validates :user_type, inclusion: { in: user_types.keys, message: "should be one of #{user_types.keys.join(', ')}"}
  validates :profile_type, inclusion: { in: profile_types.keys, message: "should be one of #{profile_types.keys.join(', ')}"}

  scope :get_support_closer_user,-> { support_closer.order(created_at: :desc)}
  scope :get_all_buyer,-> { want_buy.order(created_at: :desc)}
  scope :get_all_seller,-> { want_sell.order(created_at: :desc)}
  scope :get_new_user,-> { order(created_at: :desc)}
  scope :count_active_user, -> { where('active = (?)',true) }
  scope :count_support_closer_user, -> { support_closer.count }
  scope :all_users, -> { where.not(profile_type: 'support_closer')}
  scope :new_users, -> { where('created_at >= :five_days_ago', :five_days_ago => 5.days.ago) }

  def user_type=(value)
    self.class.user_types.has_key?(value) ? super : nil
  end

  def profile_type=(value)
    self.class.profile_types.has_key?(value) ? super : nil
  end

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

  def subscribed?
    subscription.present? && !subscription.status.in?(['canceled', 'incomplete_expired'])
  end

  private

    def generate_otp
      otp_length(6)
    end

    def otp_length(length)
      rand((9.to_s * length).to_i).to_s.center(length, rand(9).to_s).to_i
    end

    def create_user_preference
      build_user_preference(property_type: 'house')
    end

    def self.to_csv
      CsvCounter.update_csv_counter
      CSV.generate(headers: true) do |csv|
        csv << CsvCounter.titlize_csv_headers(self.attribute_names)
        all.each do |record|
          csv << record.attributes.values_at(*attribute_names)
        end
      end
    end

end
