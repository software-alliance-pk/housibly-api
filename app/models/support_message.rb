class SupportMessage < ApplicationRecord
  has_one_attached :image, dependent: :destroy
  has_one_attached :file, dependent: :destroy
  belongs_to :support_conversation

  validate :image_content_type, if: -> { image.attached? }
  validate :file_content_type, if: -> { file.attached? }

  private

  def image_content_type
    unless image.content_type.in?(%w(image/png image/gif image/jpeg))
      errors.add(:image, 'must be a PNG, GIF, or JPEG image')
    end
  end

  def file_content_type
    unless file.content_type.in?(%w(application/pdf))
      errors.add(:file, 'must be a PDF file')
    end
  end
end