class ReviewsController < ApplicationController


    # check if logged in
    before_action :check_login, except: [:index, :show]

    # list all of the reviews
    def index

        @price = params[:price]
        @cuisine = params[:cuisine]
        @location = params[:location]
    
        #start with all reviews
        @reviews = Review.all

        #filtering by price
        if @price.present?
            @reviews = @reviews.where(price: @price)
        end

        #filter by cuisine
        if @cuisine.present?
            @reviews = @reviews.where(cuisine: @cusine)
        end

        #filter near Location
        if @location.present?
            # return all reviews that are in a 1 mile radius of the search term
            @reviews = @reviews.near(@location, 1)
        end

    end

    # define a new review
    def create
        # take info from form and add to model
        @review = Review.new(form_params)

        # Save Review to user
        @review.user = @current_user


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
        
        if @review.user == @current_user
            # destroy it if they have access
            @review.destroy
        end
        # redirect to homepage
        redirect_to root_path
    end

    # edit a review - you would only want this visible to administrators
    def edit 
        # find the review to edit
        @review = Review.find(params[:id])
        
        if @review.user != @current_user
            redirect_to root_path
        end
    end

    # update the edited review in the database
    def update 
        # find review
        @review = Review.find(params[:id])
        
        if @review.user != @current_user
            redirect_to root_path
        else
            # update with new info
            if @review.update(form_params)
                # redirect to somewhere new
                redirect_to review_path(@review)
            else 
                render "edit"
            end
        end
    end

    def form_params
        params.require(:review).permit(:title, :address, :restaurant, :body, :score, :ambience, :price, :cuisine)
    end

end
