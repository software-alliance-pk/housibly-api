class Review < ApplicationRecord
  belongs_to :user
  belongs_to :support_closer, class_name: 'User', foreign_key: :support_closer_id

  validates_presence_of :rating

  scope :total_review_count, -> (id){where(support_closer_id: id).count}
  scope :review_count_for_rating, -> (id, rating){where(support_closer_id: id, rating: rating).count}
end
