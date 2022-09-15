class Review < ApplicationRecord
    belongs_to :user
    belongs_to :support_closer, class_name: "User", foreign_key: :support_closer_id

    scope :get_reviews, -> (id){ where(support_closer_id: id)}
    scope :get_reviews_count, -> (id){where(support_closer_id: id).count}

    def self.get_support_closer_average_rating(id)
        begin
        rating = Review.get_reviews(id).pluck(:rating)
        rating.sum/rating.count
        rescue
            0
        end
    end
end
