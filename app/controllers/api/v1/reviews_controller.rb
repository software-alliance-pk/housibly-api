class Api::V1::ReviewsController < Api::V1::ApiController
   def create
    @user = User.find_by(id: params[:support_closer_id])
    if @user.present?
      if @user.want_support_closer?
        @review = @current_user.reviews.build(review_params.merge(support_closer_id: @user.id))
        if @review.save
          @review
        else
          render_error_messages(@review)
        end
      else
        render json: {message: "This user is not Support Closer"}, status: :unprocessable_entity
      end
    else
      render json: {message: "User does n't exists"}, status: :unprocessable_entity
    end
  end

  def get_reviews
    @reviews = Review.get_reviews(params[:support_closer_id])
    if @reviews.present?
      @reviews
    else
      render json: {message: "Support Closer does n't exists"}
    end
  end

  def review_filter
    @reviews = Review.where(rating: params[:rating],support_closer_id: params[:support_closer_id] )
    if @reviews.present?
      @reviews
    else
      render json: {reviews: []}, status: :ok
    end
  end
  private
  def review_params
    params.require(:review).permit(:description, :rating)
  end

end
