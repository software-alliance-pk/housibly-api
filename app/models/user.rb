class User < ApplicationRecord
  # before_create :generate_confirmation_token
  # after_create :send_confirmation_email

  has_secure_password
  has_one_attached :avatar
  validates :email, presence: true, uniqueness: true
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
