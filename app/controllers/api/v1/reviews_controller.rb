class Api::V1::ReviewsController < Api::V1::ApiController
   def create
    @support_closer = User.find_by(id: params[:support_closer_id])
    if @support_closer.present?
      @review = @current_user.reviews.build(review_params)
      @review.support_closer_id = @support_closer.id
      if @review.save
        @review
      else
        render_error_messages(@review)
      end
    else
      render json: {message: "Not Found"}, status: :unprocessable_entity
    end
  end

  def index
    @reviews = Review.where(support_closer_id: params[:support_closer_id])
    if @reviews.present?
      @reviews
    else
      render json: {message: "Not Found"}
    end
  end

  def review_filter
    @reviews = Review.where(rating: params[:rating])
    if @reviews.present?
      @reviews
    else
      render json: {message: "Reviews Not Found"}
    end
  end
  private
  def review_params
    params.require(:review).permit(:description, :rating)
  end

end
