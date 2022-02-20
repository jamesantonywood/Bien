class CommentsController < ApplicationController

    def create
        # What review did we leave a comment on?
        # We get the review id because we nested comments in the routes file
        @review = Review.find(params[:review_id])

        # the new comment is to be added to the comments field in the reviews db table
        @comment = @review.comments.new(params.require(:comment).permit(:body))

        # save the comment
        @comment.save

        # go back to the review page
        redirect_to review_path(@review)
    end

end
