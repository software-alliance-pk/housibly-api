# frozen_string_literal: true

class Api::V1::ReviewsController < Api::V1::ApiController

  def create
    user = User.find_by(id: review_params[:support_closer_id])
    return render json: { message: 'User does not exist' }, status: :not_found unless user.present?

    return render json: { message: 'You cannot review yourself!' }, status: 422 if @current_user.id == user.id

    return render json: { message: 'User is not a support closer' }, status: 422 unless user.support_closer?

    @review = @current_user.reviews.build(review_params)
    unless @review.save
      render_error_messages(@review)
    end
  end

  def get_reviews
    if review_params[:rating].present?
      @reviews = Review.where(support_closer_id: review_params[:support_closer_id], rating: review_params[:rating]).paginate(page_info)
      @review_count = Review.review_count_for_rating(review_params[:support_closer_id], review_params[:rating])
    else
      @reviews = Review.where(support_closer_id: review_params[:support_closer_id]).paginate(page_info)
      @review_count = Review.total_review_count(review_params[:support_closer_id])
    end
  end

  private

    def review_params
      params.require(:review).permit(:support_closer_id, :description, :rating)
    end

    def page_info
      {
        page: params[:page],
        per_page: 10
      }
    end
end
