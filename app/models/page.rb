class Page < ApplicationRecord
  has_rich_text :content
  has_paper_trail
  belongs_to :admin

  validates :permalink,  uniqueness: true
end
