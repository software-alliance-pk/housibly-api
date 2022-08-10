class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar
  has_one :user_preference, dependent: :destroy
  has_many :dream_addresses, dependent: :destroy
  has_many :properties, dependent: :destroy
  has_many :supports, dependent: :destroy
  has_many :card_infos, dependent: :destroy

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
end
