class User < ApplicationRecord
  # before_create :generate_confirmation_token
  # after_create :send_confirmation_email
  #
  has_secure_password
  has_one_attached :avatar

  validates :full_name, :email, :phone_number, :description, :user_type,
            :profile_type, :password_digest, :password_digest, presence: true
  validates_inclusion_of :contacted_by_real_estate, :licensed_realtor, in: [true, false]
  validates :phone_number, format: { with: /\A[+-]?\d+\z/ }
  validates :email, uniqueness: { case_sensitive: false }
  validates :password_digest, length: { minimum: 6 }, confirmation: true
  validates :user_type, inclusion: { in: %w(seller buyer neither) }

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

  def generate_password_token!
    self.reset_password_token = generate_otp
    self.reset_password_sent_at = Time.now.utc
    self.save!
  end
  def password_token_valid?
    (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end
  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    self.save!
  end

  private
  def generate_otp
    SecureRandom.hex(3)
  end

  # def confirm?
  #   confirmed_at?
  # end

  # def generate_confirmation_token
  #   self.confirmation_token = secureRandom.hex(10)
  #   self.confirmation_sent_at = Time.now
  # end

  # def send_confirmation_email
  #   SendConfirmationInstructionJob.perform_now(self.confirmation_token)
  # end
end
