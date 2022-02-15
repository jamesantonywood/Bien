class ReviewsController < ApplicationController

    # list all of the reviews
    def index
        # This function handles the 'list' page of reviews
        @reviews = Review.all
    end

    # define a new review
    def create
        # take info from form and add to model
        @review = Review.new(form_params)
        # if the model passes validation
        if @review.save
            # redirect to the homepage
            redirect_to root_path
        else
            #otherwise show the new view
            render "new"
        end
    end

    # create the new review in the database
    def new
        # Handle new page
        @review = Review.new
    end

    # show the review based on the id in the URL
    def show
        # the individual review page
        @review = Review.find(params[:id])
    end

    # remove the review from he database
    def destroy
        # find the individual review
        @review = Review.find(params[:id])
        # destroy it
        @review.destroy
        # redirect to homepage
        redirect_to root_path
    end

    # edit a review - you would only want this visible to administrators
    def edit 
        # find the review to edit
        @review = Review.find(params[:id])
    end

    # update the edited review in the database
    def update 
        # find review
        @review = Review.find(params[:id])
        # update with new info
        if @review.update(form_params)
            # redirect to somewhere new
            redirect_to review_path(@review)
        else 
            render "edit"
        end
    end

    def form_params
        params.require(:review).permit(:title, :body, :score)
    end

end
