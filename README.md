# NOTES

## Rails

Rails is built on convention: There is a way to think about certain things

---

## MVC

- Stands for Model View Controller

### Model

- In the database
- Similar to post-type

### View

- HTML Content that changes

### Controller

- Sits inbetween the Model and the View
- Take the URL and find the right db Model and the right view to inject the data into

---

## Generating a Controller

```bash
~rails generate controller reviews
```

This generates-

- app/controllers/reviews_controller.rb
- app/views/reviews
- app/controllers/reviews_controller_test.rb
- app/helpers/reviews_helper.rb
- app/assets/javascripts/reviews.coffee
- app/assets/stylesheets/reviews.scss

---

### Routes

[Rails Routing Guide](https://guides.rubyonrails.org/routing.html)

in: _'config/routes.rb'_

```ruby
Rails.application.routes.draw do
  # Code Here
end
```

Adding a resource (rails convention).

```ruby
Rails.application.routes.draw do
  resources :reviews
  root "reviews#index"
end
```

_returns_ The action 'index' could not be found for ReviewsController message in browser.

This is because there is no index method on the reviews controller.

controller#methodName

---

### Setting up the page

Currently the controller isnt doing anything.

in: _'app/controllers/reviews_controller.rb'_

This is a Class that inherites Rails' ApplicationController Class

```ruby
class ReviewsController < ApplicationController

  def index
    # This function handles the 'list' page of reviews
  end

end
```

Right now the Controller is set up to handle the index but it has no View or Model to use

---

## Creating the View

in: _'app/views'_

we have

- '/layouts'
- '/reviews'

in: _'app/views/reviews'_

add: _'index.html.erb'_

The _.erb_ extention to the HTML is an 'embedded ruby file.' It will let us embed ruby into our 'template'

Now our controller is automatically looking in: _'app/views/reviws'_ (looking for a views folder that shares the same name) and running the template —- in this case it is index.html.erb

! I DON'T KNOW AT THE MINUTE IF IT WILL ALWAYS RUN AN INDEX OR IF IT IS LOOKING FOR THE METHOD NAME

- Route (Looks for controller and method)
- Controller (Outlines Methods)
- View (Renders the request)

---

## Adding Variables to Views

The idea of Ruby is to dynamically change webpages

### Example Generate Random Number

in: _'app/controllers/reviews_controller.rb'_
in: _'index method'_

Creating a variable

```ruby
@number = rand(100)
```

And we can use it
in: _'app/views/reviews/index.html.erb'_

```html
<p>The Random Number is <%= @number %></p>
```

---

## Looping in Views

in: _'app/controllers/reviews_controller.rb'_

```ruby
@reviews = [
  "The Smile",
  "Baby Bo's",
  "Chipotle"
]
```

in: _'app/views/reviews/index.html.erb'_

```html
<!-- loop over @reviews -->
<% @reviews.each do |review| %>

<div class="review"><%= review %></div>

<% end %>
```

---

## The application HTML

in: _'app/views/layouts/application.html.erb'_

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Bien</title>
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <%= csrf_meta_tags %> <%= csp_meta_tag %> <%= stylesheet_link_tag
    'application', media: 'all', 'data-turbolinks-track': 'reload' %> <%=
    javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
  </head>

  <body>
    <header></header>
    <!-- Print Page Specific Content  -->
    <%= yield %>
    <!-- / -->
    <footer></footer>
  </body>
</html>
```

This is a wrapper for a basic html page - saves having all of the HTML gunk on a given page.

This is also the start of thinking with _partials_

---

## The link-to Helper

in: _'app/views/layouts/application.html.erb'_

```html
<!--Adding a new review link-->
<!-- This is a routing error because rails doesnt know what newreview.html is -->
<a href="/newreview.html">Add a review</a>

<!-- Using Rails' link_to helper -->
<nav>
  <%= link_to "home", root_path %> <%= link_yo "Add a new review",
  new_review_path %>
</nav>
```

adding a #new method to the review controller

in: _'app/controllers/reviews_controller.rb'_

```ruby
# Add a new method to the controller
def new
  # Handle new page
end
```

in: _'app/views/reviews'_

add: _'new.html.erb'_

```html
<h3>Add Your New Restaurant Review</h3>
```

in here we might have a form that would submit to the db

---

### Checking Routes

Checking the routes available to our rails application can give us an idea of how to handle certain actions.

Exit out of the server

```bash
~ rails routes
```

```text

  Prefix Verb       |   URI Pattern                   |   Controller#Action
  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  reviews GET       |   /reviews(.:format)            |   reviews#index
  ------------------------------------------------------------------------------
  POST              |   /reviews(.:format)            |   reviews#create
  ------------------------------------------------------------------------------
  new_review GET    |   /reviews/new(.:format)        |   reviews#new
  ------------------------------------------------------------------------------
  edit_review GET   |   /reviews/:id/edit(.:format)   |   reviews#edit
  ------------------------------------------------------------------------------
  review GET        |   /reviews/:id(.:format)        |   reviews#show
  ------------------------------------------------------------------------------
  PATCH             |   /reviews/:id(.:format)        |   reviews#update
  ------------------------------------------------------------------------------
  PUT               |   /reviews/:id(.:format)        |   reviews#update
  ------------------------------------------------------------------------------
  DELETE            |   /reviews/:id(.:format)        |   reviews#destroy
  ------------------------------------------------------------------------------
  root GET          |   /                             |   reviews#index
  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------

```

---

## The M in MVC. The Model

A basic DB table w/ some placeholder rows. Each row corresponds to an individual review.

```text

  Title          |   Body          |   Score   |   User       |   Price   |   cuisine
  --------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------
  Review Title   |   Review Body   |   9/10    |   username   |    $$     |   italian
  --------------------------------------------------------------------------------------
  Review Title   |   Review Body   |   9/10    |   username   |    $$     |   italian
  --------------------------------------------------------------------------------------
  Review Title   |   Review Body   |   9/10    |   username   |    $$     |   italian
  --------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------

```

### Generating the model

Statring with a simple model for our reviews

exit server

```bash
~rails generate model Review title:string body:text score:integer restaurant:string price:integer cuisine:string
```

This sets up our simple model with some fields

This generates-

- db/migrate/20220213205902_create_reviews.rb
- app/models/review.rb
- test/models/review_test.rb
- test/fixtures/reviews.yml

_'db/migrate/20220213205902_create_reviews.rb'_ is a file that tells the database to create a new table.

```ruby
class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.string :title
      t.text :body
      t.integer :score
      t.string :restaurant
      t.integer :price
      t.string :cuisine

      t.timestamps
    end
  end
end
```

There is a difference between our code and the database itself

- The code will run actions and grab data from the database
- The database unsuprisingly stores data

Right now we have created the 'code' but we haven't told our database to update.

Rails comes with sqlite

```bash
rails db:migrate
```

updates the database, runs the migration and any that hasnt been ran yet.

! Its important to check the migration file 'code' for typos and mistakes

When we go online the database will be different
local DB gives us a chance to test data

---

### Adding a form

in: _'app/controllers/reviews_controller.rb'_

Create access to new entry in the model.

```ruby
def new
  @review = Review.new
end
```

in: _'app/views/new.html.erb'_

```html
<%= form_for @review do |f| %>

<p><%= f.label :title %> <%= f.text_field :title %></p>

<p><%= f.label :body %> <%= f.text_area :body %></p>

<p><%= f.label :score %> <%= f.number_field :score %></p>

<%= f.submit "Save Review" %>
```

find out more by googling _rails input helpers_

---

### Creating and saving the review

The form needs to call the #create action
This will create a new row in the database

in: _'app/controllers/reviews_controller.rb'_

```ruby
def create
  # take info from form and add to database
  @review = Review.new(params.require(:review).permit(:title, :body, :score))

  # save this to the database
  @review.save

  # redirect back to the homepage
  redirect_to root_path

end
```

update index method to have reviews pulled from database

```ruby
 def index
    # This function handles the 'list' page of reviews
    @reviews = Review.all

end

```

_returns_ an array of '#<Review:0x00007fea2ab86ac0>'

access the data from the model in HTML view

in: _'app/views/reviews/index.html.erb'_

```html
<div class="review"><%= link_to review.title, review_path(review) %></div>
```

---

### Adding a show page

This is for the inner review page
We need to add a show method

in: _'app/controllers/reviews_controller.rb'_

```ruby
def show
  # the individual review page
  @review = Review.find(params[:id])
end
```

add: -'app/views/reviews/show.html.erb'-

in: _'app/views/reviews/show.html.erb'_

```html
<h1><%= @review.title %></h1>
<p><%= @review.score %> / 10</p>

<div><%= @review.body %></div>
```

---

### A Simple format helper

This works like a simple version of wp_auto_p

in: _'app/views/reviews/show.html.erb'_

```html
<h1><%= @review.title %></h1>
<p><%= @review.score %></p>

<div><%= simple_format @review.body %></div>
```

---

## Deleting Reviews

uses the #destroy method

```text

  ------------------------------------------------------------------------------
  DELETE            |   /reviews/:id(.:format)        |   reviews#destroy
  ------------------------------------------------------------------------------

```

in: _'app/views/reviews/show.html.erb'_

```html
<div class="actions">
  <%= link_to "Delete Review", review_path, method: :delete %>
</div>
```

in: _'app/controllers/reviews_controller.rb'_

```ruby
def destroy
  # find the individual review
  @review = Review.find(params[:id])
  # destroy it
  @review.destroy
  # redirect to homepage
  redirect_to root_path
end
```

Add a confirmation

in: _'app/views/reviews/show.html.erb'_

```html
<%= link_to "Delete Review", review_path, method: :delete, data: {confirm: "Are
you sure?"} %>
```

---

## Editing Reviews

Add an edit link on the page

needs the edit and update routes

```text
  
  ------------------------------------------------------------------------------
  edit_review GET   |   /reviews/:id/edit(.:format)   |   reviews#edit
  ------------------------------------------------------------------------------
  PUT               |   /reviews/:id(.:format)        |   reviews#update
  ------------------------------------------------------------------------------

```

in actions div in: _'app/views/reviews/show.html.erb'_

We want to add the edit link

```html
<%= link_to "Edit this Review", edit_review_path(@review) %>
```

then in the controller in: _'app/controllers/reviews_controller.rb'_

```ruby
def edit
  # find the review to edit
  @review = Review.find(params[:id])
end
```

then we need an edit view

add: _'app/views/reviews/edit.html.erb'_

in this file

```html
<h3>Edit your Restaurant Review</h3>

<%= form_for @review do |f| %>

<p><%= f.label :title %> <%= f.text_field :title %></p>

<p><%= f.label :body %> <%= f.text_area :body %></p>

<p><%= f.label :score %> <%= f.number_field :score %></p>

<%= f.submit "Save your edit"%> <% end %>
```

Then update

in: _'app/controllers/reviews_controller.rb'_

```ruby
def update
  # find review
  @review = Review.find(params[:id])
  # update with new info
  @review.update(params.require(:review).permit(:title, :body, :score))
  # redirect to somewhere new
  redirect_to review_path
end
```

---

## Cleaning code

in: _'app/controllers/reviews_controller.rb'_

```ruby
def form_params
  params.require(:review).permit(:title, :body, :score)
end

# then in update and create...
# @review.update(form_params)
# saves repetition

```

---

### Making use of partials

for the form...

add: _'_form.html.erb'_

the _ file prefix tells rails it is a partial

```html
<%= form_for @review do |f| %>

<p><%= f.label :title %> <%= f.text_field :title %></p>

<p><%= f.label :body %> <%= f.text_area :body %></p>

<p><%= f.label :score %> <%= f.number_field :score %></p>

<%= f.submit "Save your edit"%> <% end %>
```

then in HTML files

```html
<%= render "form" %>
```

---

## Images and Stylesheets

these are located in: _'app/assets/'_

add: _'global.scss'_ to _'app/assets/stylesheets/'_

here I can structure SASS however I want

!! It would be interesting to see how POSTCSS and other preprocessors would be added to a project

adding an image

```html
<%= image_tag "bien-logo.svg" %>

<!-- Wrapping tags... -->
<h1>
  <%= link_to root_path do %> <%= image_tag "bien-reviews.svg" %> <% end %>
</h1>
```

---

## Ruby Syntax

```ruby

  # How variables work

  ## Numbers
  @number = 13
  @number = 14
  # number === 14

  ## Strings
  @username = "jameswood" + "admin"

  ## Symbols
  # We cant ever change a symbol
  @method = :delete

  ## Arrays
  @shopping_list = ["eggs", "bacon", "sausages"]

  ## Hashes - similar to objects
  @person = { 
    first_name: "James", 
    age: 26, 
    shopping: ["eggs"] 
  }

  ## Hash with a key as a symbol
  @link = { method: :delete }


```

# Week 2

## Checking data with model validations

Data lives with the models and are the gateholders

[Active Record Validations](https://guides.rubyonrails.org/active_record_validations.html)

Active record is what ruby uses to check and look after data.

in _'app/models/review.rb'_

generated

```ruby
class Review < ApplicationRecord
end
```

```ruby
class Review < ApplicationRecord
  validates :title, presence: true
  validates :body, length: { minimum: 10 }
  validates :score, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
end
```
validates model input to see if is allowed to save, currently redirects to post if invalid without updating

conditional redirect if invalid goto edit view with error messages
else goto post with edits completed

---

## Reopening project

ALWAYS start with a git pull
Then run server and take a look at the site
Then start working in a Text Editor

---

## Fixing controllers for validations

in: _'app/controllers/reviews_controller.rb'_

```ruby
   
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

```

Also need this in update action

```ruby

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

```

---

## Using to_param to make SEO-friendly URLs

Currently the reviews have a slug that is akin to the following

root/reviews/5

and for SEO and legibility it would be better to have

root/reviews/review-title

in _'app/models/review.rb'_

default slug is

```ruby

  #default deep within rails
  def to_param
    id.to_s
  end  

  # overwrite in the model
  def to_param
    id.to_s + "-" + title
  end  

  #produces: 5-Hello%20World

  #url friensly form

  def to_param
    id.to_s + "-" + title.parameterize
  end  
  #produces: 4-hello-world

```

## Adding page titles with content_for

in the application wrapper html 

_'app/views/layouts/application.html.erb'_

```html
  
  <title><%= content_for :page_title  %> - Bien Revies – Bien reviews the best restaurants in the world</title>

```

:page_title is a symbol because its never going to change across the site

Then in our reviews views (show, new, index, edit)

```html
  
  <!-- What is the symbol?, what is its value -->
  <!-- Show Page -->
  <% content_for :page_title, @review.title %>

  <!-- New Page -->
  <% content_for :page_title, "Add a new review" %>

```

## Uncovering field in the Database

The model is not the database

The model is a tool for interacting and controlling the database

in: _'db/migrate'_

there are a number of files called migrations

migrations are files that tell rails what to do with the database

currently there is one migration that tells the database to: 

- Create a table called reviews
- Add the fields detailed in the migration with their data-type

in: '/db/'

there is also a 'schema.rb' file

This is a final version of what the database looks like

---

To add a new field to our reviews that already exists in the database
in this case the 'retaurant' field

we have to update the M, V and C

we update the model to validate the input
we update the views to display the field (in new, edit or a form partial for both of these) and to render the data (show)
we update the controller that says what is being submitted, in this case it is in our custom form_params method:

```ruby

  def form_params
     # what can be submitted to the model and then in turn the database?
        params.require(:review).permit(:title, :body, :score, :restaurant)
    end


```


## Adding new database fields with migrations

If a client wants extra fields for their reviews that we dont have in our database

we do this with migrations

eg. phone number, ambience

we want to make two new columns in the database

in terminal

```bash

~ Rails generate migration add_new_info_to_reviews 

```

[info on migrations](https://guides.rubyonrails.org/active_record_migrations.html)

in the newly generated migration file 

```ruby

  class AddNewInfoToReviews < ActiveRecord::Migration[6.1]
    def change

      add_column :reviews, :phone_number, :string
      add_column :reviews, :ambience, :string

    end
  end

```
Make sure migration file is checked and double-checked as its harder to rollback


back in terminal
run the migrations

```bash

~ Rails db:migrate

```

then check 'schema.rb' to see the new columns/updates

we can then use these new fields in the application

if a field is to be optional we dont need to validate it in the model, we can however continue to use it in the views as we have been
(remember to update the controller to allow the new data to be submitted)

```html
<% if @review.ambience.present? %>
  <div class="ambience">
      <p><%= @review.ambience %></p> 
  </div>
<% end %>
```

## Filtering our params

A user should be able to search by location and filter by price and cuisine

in index action of controller and index.html.erb


### using the query string...

if there is a filter return those reviews that match otherwise return all reviews

```ruby

  def index
    @price = params[:price]

    if @price.present?
      #filter by price
      ...?
    else
      # all reviews
      Reviews.all
    end

  end

```

## Filtering with our reviews controller

```ruby

  def index
    # query sting params are saved in params with symbols {:price : value}
    @price = params[:price]

    if @price.present?
      #filter by price
      @reviews = Review.where(price: @price)
    else
      # all reviews
      @reviews = Review.all
    end

  end

```

```html

  <nav class="filters">
    <%= link_to "All Prices", root_path %>
    <%= link_to "$", root_path(price: 1) %>
    <%= link_to "$$", root_path(price: 2) %>
    <%= link_to "$$$", root_path(price: 3) %>
  </nav>

```


## Adding multiple filters in one controller action

filter multiple params
```ruby

  def index

    @price = params[:price]
    @cuisine = params[:cuisine]

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

  end

```


update links to include both params so both can be included in the filter, not needed if one filter at a time is required

```html

  <nav class="filters">
      <%= link_to "All Prices", root_path %>
      <%= link_to "$", root_path(price: 1, cuisine: @cuisine) %>
      <%= link_to "$$", root_path(price: 2, cuisine: @cuisine) %>
      <%= link_to "$$$", root_path(price: 3, cuisine: @cuisine) %>

      <%= link_to "Indian", root_path(cuisine: "Indian", price: @price) %>
  </nav>

```

---

## Adding geolocation using the geocoder gem

[Awesome ruby gems](https://github.com/markets/awesome-ruby)

[Geocoder](https://github.com/alexreisner/geocoder)

Gems are libraries for specific tasks

Rails is like one big gem

```bash

  ~gem install geocoder

```

or in the gemfile

```ruby

  gem 'geocoder'

```

and run in bash

```bash

  ~bundle install

```

Geocoder wants latitude and longitude columns in the database to work with so we need to add this to the reviews with a migration...


```bash
~rails generate migration add_location_to_reviews
```

then in the newly generated migration db/migrate

```ruby
class AddLocationToReviews < ActiveRecord::Migration[6.1]
  def change

    add_column :reviews, :address, :text
    add_column :reviews, :latitude, :float
    add_column :reviews, :longitude, :float

  end
end

```

in review model, app/models/review.rb

```ruby
class Review < ApplicationRecord
    # Geocoder
    geocoded_by :address
    after_validation :geocode

    # Check model input
    validates :title, presence: true
    validates :body, length: { minimum: 10 }
    validates :score, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
    validates :restaurant, presence: true
    validates :address, presence: true

    def to_param
        id.to_s + "-" + title.parameterize
    end  

end
```

M is done, now we need V: form, show, etc.

```html
<p>
  <%= f.label :restaurant %>
  <%= f.text_field :restaurant %>
</p>
```

Now for C controller for geocoder

```ruby
  
  def form_params
      params.require(:review).permit(:title, :address, :restaurant, :body, :score, :ambience, :price, :cuisine)
  end

```

! Addresses have to be spelled correctly... 

---

## Filtering by location

in controller#index

```ruby
  
  #filter near Location
  if @location.present?
      # return all reviews that are in a 1 mile radius of the search term
      @reviews = @reviews.near(@location, 1)
  end

```

---

## Adding a search location form

in index.erb.html

```html

  <form action="/">
      <input type="text" name="location" placeholder="search location..." value="<%= @location %>">
      <input type="hidden" name="price" value="<%= @price %>">
      <input type="hidden" name="cuisine" value="<%= @cuisine %>">
  </form>

```

---

## Making our forms simple using simple_form

[simple form github](https://github.com/heartcombo/simple_form)

add simple form to the gemfile and install the bundle.

then we can install simple form into the application by

```bash
  
  $ rails generate simple_form:install

  # outputs
  create  config/initializers/simple_form.rb
  exist  config/locales
  create  config/locales/simple_form.en.yml
  create  lib/templates/erb/scaffold/_form.html.erb

```

simple form reduces the amount of code needed for the input form

in _'_form.html.erb'_ partial we can replace the verbose markup with 

```html

  <%= simple_form_for @review do |f|%>
    <%= f.input :title %>
    <%= f.input :restaurant %>
    <%= f.input :address %>
    <%= f.input :body %>
    <%= f.input :cuisine %>
    <%= f.input :price %>
    <%= f.input :score %>
    <%= f.input :ambience %>

    <%= f.button :submit %>
  <% end %>

``` 

This will also give us extra handy tools such as marking required fields, displaying errors next to input's with errors and giving error classes to inputs for styling.

---

## Highlighting our links with active_link_to

[active_link_to gem](https://github.com/comfy/active_link_to)

```html

  <%= active_link_to "All Restaurants", root_path, active: { price: nil, cuisine: nil, location: nil } %>
  <div>
    <%= active_link_to "$", root_path(price: 1, cuisine: @cuisine, location: @location), active: { price: 1 } %>
    <%= active_link_to "$$", root_path(price: 2, cuisine: @cuisine, location: @location), active: { price: 2 } %>
    <%= active_link_to "$$$", root_path(price: 3, cuisine: @cuisine, location: @location), active: { price: 3 }  %>
  </div>
  <div>
    <%= active_link_to "Indian", root_path(cuisine: "Indian", price: @price), active: { cuisine: "Indian" }  %>
  </div>

```

---

# Introducing Comments

Any data-type needs an MVC structure. If this site was to list job positions this would be a new MVC Model(Job), Views(index, show, new, edit), Controller(jobs_controller).
Data types stand alone but we can make them talk to each other with a 'relationship'

For instance Reviews might have Comments, this would be a 'one-to-many' relationship

Relationships can be 

- one-to-one
- one-to-many
- many-to-many

---

## One-to-many Relationships

Comments are their own data-type or another table in the database

one Review can have many comments but a comment cant have many reviews.

This is what makes it a one-to-many relationship

An illustration of a comments table

```text

  User       |   Body                 |   Review ID   |
  -----------------------------------------------------
  -----------------------------------------------------
  James      |   Expensive! :o        |   4           |
  -----------------------------------------------------
  Chloe      |   So Nice!             |   4           |
  -----------------------------------------------------
  Charlie    |   Meow!                |   1           |
  -----------------------------------------------------
  -----------------------------------------------------

```

---

## Adding the comments model

```bash
rails generate model Comment body:text review:belongs_to

# Check generated migration to see if the information is correct then...
rails db:migrate

# Make the database in sync

```

in review.rb model

```ruby

  # add an association that has a 1-to-many relationship
  has_many :comments

```

in comment.rb model

```ruby
class Comment < ApplicationRecord
  belongs_to :review

  validates :body, presence: true

end
```

Now the groundwork is laid for the two data-types to work together but it wont work just yet.

Still need a UI for users to leave comments
and the controller actions to save and display comments

---

## creating the comments controller

For now - until we have an admin system - users can only add comments not edit and update

```bash

  rails generate controller comments

```

---

### set up routes

```ruby
Rails.application.routes.draw do
  resources :reviews do 
    resources :comments
  end

  root "reviews#index"
end
```

having the comments resource in a do-end after reviews ties the comments to the reviews

in reviews show page

```

<!-- Adding the 'add comment' form -->

<h3>Add a comment</h3>

<%= simple_form_for [@review, Comment.new] do |f| %>
    <%= f.input :body, label: "Type your comment here" %>
    <%= f.button :submit, "Comment" %>
<% end %>

```

and in the comments controller

```ruby

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

```

---


### showing the comments

in reviews show page

```html
<h3>Comments</h3>

<% @review.comments.each do |comment| %>
    <div class="comment">
        <%= simple_format comment.body %>
        <p>Posted at: <%= comment.created_at %></p>
    </div>
<% end %>
```

[rails date helpera](https://api.rubyonrails.org/v6.1.4/classes/ActionView/Helpers/DateHelper.html)

updated show

```html
<h3>Comments</h3>

<% @review.comments.order_by('created_at desc').each do |comment| %>
    <div class="comment">
        <%= simple_format comment.body %>
        <p>Posted at: <%= time_ago_in_words comment.created_at %> ago</p>
    </div>
<% end %>
```

---


## showing comments count on reviews index

[Rails pluralize](https://apidock.com/rails/ActionView/Helpers/TextHelper/pluralize)

```html

<% @reviews.each do |review| %>

  <div class="review">
      <%= link_to review_path(review) do %>
          <h2><%= review.title %></h2>
          <p>
              <%= review.cuisine %> - 
              <%= pluralize review.comments.count, "comment" %>
          </p>

      <% end %>
  </div>

<% end %>

```

---


# Going live with Heroku

follow heroku docs to set up the CLI 

run heroku login

in gemfile

```ruby
#update database to pg for production only

group development do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3', '~> 1.4'
end

group production do
  gem 'pg'
end
```

solved bundle install issue when deploying to heroku
```text
I have same issue: remote: ! Failed to install gems via Bundler.

if you see the problem is this:

remote:  Your bundle only supports platforms ["x86_64-darwin-16"] but your local platform
remote:  is x86_64-linux. Add the current platform to the lockfile with `bundle  loc
remote:  --add-platform x86_64-linux` and try again.
its mean this :

Your bundle only supports platforms ["x86_64-darwin-16"] but your local platform is x86_64-linux. Add the current platform to the lockfile with `bundle loc --add-platform x86_64-linux` and try again.
If you see in your gemfile.loc you only have this :

PLATFORMS
  x86_64-darwin-16
So I did this command, To add in your platform in gemfile.loc

bundle lock --add-platform x86_64-linux
This will update your Gemfile.loc :

PLATFORMS
  x86_64-darwin-16
  x86_64-linux
Continue :

git add .
git commit -m "add platform x86_64-linux"
Push again

git push heroku master:main
Solve!
```

---

## set up db on heroku

start commands with

heroku run

migrate the database

heroku run rails db:migrate

---

# HOMEWORK
Add this profanity filter to comments
[profanity filter](https://github.com/mobomo/profanity_filter)

Added this to the view first but it is better to do this in the model. 

The model is the point where we get data, filtering profanity here means we always have the filtered data when creating new Views. Better than having to remember to sanitize input. Keeps code DRY and can prevent simple errors.

---

---


# Week 3


## User System Gems

user systems can vary from client to client. it is a good idea to get to grips with writing these from scratch so user systems can be taylored to client need. 

a gem might be device...

---

## User associations

Currently we have two models 

- reviews (has_many comments)
- comments (belongs_to review)
  a one to many relationship

When it comes to the User model

- A user has one-to-many relationship with reviews
- A user has one-to-many relationship with comments

---

## What is in the model

User: 
  - username (unique, required)
  - email (uniquem required)
  - password_digest (has_secure_password), encrypted, one way transformation
  - real_name (default to username if blank)

---

## The user Model

```bash
rails generate model User username:string email:string password_digest:sting real_name:string
```

model test and migration files created

check migration and then sync with database

```bash
rails db:migrate
```


Now add has_secure_password in the model
this will bcrypt the given password into a secure form and save it into the database password_digest.


in app/models/user.rb
```ruby

  class User < ApplicationRecord

    # Run has_secure_password
    has_secure_password

    # Validate username
    validtes :username, presence: true, uniqueness: true

    # Validates email
    validates :email, presence: true, uniqueness: true

    # We dont need to validate real_name becuase it is an optional field

  end

```

## adding users controller

create user controller: 

- index    | list                     |   Read
- show     | single                   |
- new      | set-up-new (show form)   |   Create
- create   | add new to db            |
- edit     | edit fields (show form)  |   Update
- update   | update db                |
- destroy  | delete                   |   Delete

for user 

index   | show all users
show    | users profile
new     | Sign up flow
create  | sign up flow

```bash
rails generate controller users
```

no way to access users because there isnt a route 

in config routes.rb

```ruby

  Rails.application.routes.draw do
    # resources sets up crud paths for the resource
    resources :reviews do 
      resources :comments
    end

    resources :users

    # root of the whole site is the reviews index
    root "reviews#index"
  end

```

## adding a simple sign up form

define new action in the controller then in the views folder add new.html.erb 

```html

  <h2>Sign Up</h2>

  <%= simple_form_for @user do |f| %>

      <%= f.input :username %>
      <%= f.input :email %>

      <%= f.button :submit, "Sign Up" %>

  <% end %>

```

## adding password field

in the model we ran has_secure_password and this will output the password_digest in our database

For this to work we need a password and a password_confirmation input as part of the sign up form. 

```html

  <h2>Sign Up</h2>

  <%= simple_form_for @user do |f| %>

      <%= f.input :username %> 
      <%= f.input :email %>
      <%= f.input :password %>
      <%= f.input :password_confirmation %>

      <%= f.button :submit, "Sign Up" %>

  <% end %>

```

## Creating Users

currently create action doesnt exist so the data passed into the form doesnt get assigned to the db

in controller

```ruby

    def create
        # take the form params
        # create a new user
        @user = User.new(form_params)
        # if its valid and it saves, go to the users index
        # if not, see the form with errors
        if @user.save
            redirect_to users_path
        else
            render "new"
        end
    end

    #DRY function for the form params
    def form_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end

```

now we need do define the list of all users

the index action

```ruby

  def index
        @users = User.all
    end


```

```html

  
  <% @users.each do |user| %>

      <p><%= user.username %> (<%= user.email %>)</p>
      <%= user.password_digest %>
  <% end %>

```

password was password
password digest returns $2a$12$ANGfiU.5qV3/VMcLElfE5OAyJdY0O2usf2PJ3f6v5CbJ3kMZXzlsS


## Introducing Sessions

sessions use cookies
cookies are small bits of information - they track you around a website
lets the browser know you are logged in

in bien we want a session that ties to each user when they are logged in

## Params vs Sessions

params give you some context for the page
eg. show param[:id]

sessions stay with you accross other pages
eg. the user stays logged in across pages... 

we need to add a Session controller
Actions:
new
create
destroy

## The Sessions Controller

```bash
rails generate controller sessions
```

Add URLs first

config/routes.rb
add: 

```ruby
  
  resources :sessions

```

```ruby

  class SessionsController < ApplicationController

      def new
          # log in form
      end

      def create
          # try to log in
          
      end

      def destroy
          # log out
      end

  end

```
add a new.html.erb in the sessions views

```html
    
  <h2>Log in to Bien</h2>

  <%# adding url arg to tell this form to go to create as it doesnt have a model %>
  <%= simple_form_for :session, url: sessions_path do |f| %>

      <%= f.input :username %>
      <%= f.input :password %>
      <%= f.button :submit, "Log In" %>

  <% end %>

```

## The log in action

```ruby

   def create
        # try to log in
        # get session params from the form
        @form_data = params.require(:session)
        # pull out the username and password from form data
        @username = @form_data[:username]
        @password = @form_data[:password]
        
        # lets check the user is who they say they are
        @user = User.find_by(username: @username).try(:authenticate, @password)

        # if user is valid
        if @user
            # go to homepage
            redirect_to root_path
        else
            # rerender login form
            render "new"
        end  
    end

```

## Adding a session on login

```ruby
  
  def create
        # try to log in
        # get session params from the form
        @form_data = params.require(:session)
        # pull out the username and password from form data
        @username = @form_data[:username]
        @password = @form_data[:password]
        
        # lets check the user is who they say they are
        @user = User.find_by(username: @username).try(:authenticate, @password)

        # if user is valid
        if @user

            ###
            # save the user to that users session
            session[:user_id] = @user.id
            ###
            ###


            # go to homepage
            redirect_to root_path
        else
            # rerender login form
            render "new"
        end  
    end

```

## Adding a session on sign up

in users controller

```ruby
def create
        # take the form params
        # create a new user
        @user = User.new(form_params)
        # if its valid and it saves, go to the users index
        # if not, see the form with errors
        if @user.save

          ###
            # Save the session with the user
            session[:user_id] = @user.id
          ###

            redirect_to users_path
        else
            render "new"
        end
    end
```
this keeps us logged in when we have signed up

## Adding sign up and log in links


in application.html.erb view

```html
  <nav>
      <% if session[:user_id].present? %>
        <%= link_to "Add a Review", new_review_path %>
      <% else %>
        <%= link_to "Sign Up", new_user_path %>
        <%= link_to "Log In", new_session_path %>
      <% end %>
    </nav>
```


## Singular Resources and log out

delete review is the same as delete session

With sessions its one thing at a time

in routes file change resources to resource to make it singular

make sure to update refs to sessions is changed to session, this case there was only one in new.html.erb: sessions_path

```resource :session```

```html

  <%= link_to "Log Out", session_path, method: :delete %>

```

then in sessions controller

```ruby

  def destroy
      # log out
      # remove the session completly
      reset_session
      # redirect to log in
      redirect_to new_session_path
  end

```

## The application controller

seeing the user that is logged in

rough and ready way...

<%= User.find(@use[:user_id]).username %>

longer but better way...

in application_controller

the application controller manages all controllers

making our own function in the applications controller

```ruby
def find_current_user
    @current_user = User.find(session[:user_id])
end
```
in any view

```<%= @current_user.username %>```
Gets the username but this could be any field i.e email


## Checking for login

Currently we break on a logout attempt 
We need to say if there is no userID then there is no user ergo we are logged out

in applications controller
``` ruby

  def find_current_user
      if session[:user_id].present? 
          @current_user = User.find(session[:user_id])
      else
          @current_user = nil
      end
  end

```

if logged out we can still add a new review by going to the /reviews/new 
address. We want to prevent this.

create a new function in application controller

```ruby

  #check login status
  def check_login
    if session[:user_id].present?
      # All Good
    else

      redirect_to new_session_path

    end
  end

```

in reviews controller at the top of the class

```ruby

  before_action :check_login

```
breaks reviews#index

we want index and show so an anonymous (not logged in) user can still view reviews.

```ruby

  before_action :check_login, except: [:index, :show]

```

## Cleaning up our code

session user id present is used alot.

create a new method in application controller

```ruby

  def is_logged_in?

    session[:user_id].present?

  end

```

we can then in our if statements replace if session[:user_id].present?
to if is_logged_in? which is more readable and DRY


a special word in ruby for the opposite of if is unless

We can change our if's where we want to act on the else to unless
to shorten the statement.


```ruby

#Reviews Controller
before_action :check_login, except: [:index, :show]

# Application Controller
def check_login
  unless is_logged_in?
      redirect_to new_session_path
  end
end
```

this now reads

Before any action except #index and #show check for a login and redirect to the homepage unless we are logged in.

we also check for login in a view

application.html.erb

```html

   <nav>
        
        <% if is_logged_in? %>
          <%= @current_user.username %>
          <%= link_to "Log Out", session_path, method: :delete %>
          <%= link_to "Add a Review", new_review_path %>
        <% else %>
          <%= link_to "Sign Up", new_user_path %>
          <%= link_to "Log In", new_session_path %>
        <% end %>
        
      </nav>

```

This wont work right away because we need to share our controller method with the views.

```ruby

  #Application Controller Top of File

  # Methods to use in views
    helper_method :is_logged_in?

```

## Updating our previous models

so far we have

- user sign up
  creating new user model and handle it with a users controller
- user log in
  with the session controller
- showing were logged in
- handling log in and log out

TODO 
- Hooking up reviews and comments to users
- User authorization
- Bookmarking



There is no relationship between comments,reviews and users
the DB needs updating to include this.

this means we need a new migration to update/ammend the database

```bash

  rails generate migration hook_up_comments_reviews_to_users 

```

```ruby

  class HookUpCommentsReviewsToUsers < ActiveRecord::Migration[6.1]
    def change

      add_column :reviews, :user_id, :integer
      add_column :comments, :user_id, :integer

    end
  end

```

```bash

  rails db:migrate

```

user.rb
``` ruby

  class User < ApplicationRecord

      has_many :reviews
      has_many :comments

      # Run has_secure_password
      has_secure_password

      # Validate username
      validates :username, presence: true, uniqueness: true

      # Validates email
      validates :email, presence: true, uniqueness: true

      # We dont need to validate real_name becuase it is an optional field

  end

```

review.rb
```ruby

  class Review < ApplicationRecord

    # add an association that has a 1-to-many relationship
    has_many :comments

    # Add an association to a user
    belongs_to :user

    # Geocoder
    geocoded_by :address
    after_validation :geocode

    # Check model input
    validates :title, presence: true
    validates :body, length: { minimum: 10 }
    validates :score, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
    validates :restaurant, presence: true
    validates :address, presence: true

    def to_param
        id.to_s + "-" + title.parameterize
    end  

end

```

comment.rb
```ruby

  class Comment < ApplicationRecord
    belongs_to :review
    belongs_to :user

    validates :body, presence: true

    profanity_filter :body, :method => 'hollow'
  end


```


## Adding users to controllers


Models are now hooked together
but the controllers arent

reviews controller
```ruby
# define a new review
    def create
        # take info from form and add to model
        @review = Review.new(form_params)

        # Save Review to user
        Review.user = @current_user


        # if the model passes validation
        if @review.save
            # redirect to the homepage
            redirect_to root_path
        else
            #otherwise show the new view
            render "new"
        end
    end
```

comments controller

```ruby
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
```

in views/reviews/show (where comments are listed)

```html
<% @review.comments.order('created_at desc').each do |comment| %>
    <div class="comment">
        <%# <%= simple_format ProfanityFilter::Base.clean(comment.body, 'hollow') %>
        <%# moved profanity filter to the model %>
        <%= simple_format comment.body %>


        <!-- Here -->
        <p class="posted">Posted By: <%= comment.user %></p>


        <p class="posted">Posted at: <%= time_ago_in_words comment.created_at %> ago</p>
    </div>
<% end %>
```

returns #<User:0x00007fadffeafb28>
which is the user model so we need to get the field. because we already had comments before this was set up it will error out because some comments dont have a user model association. We need to wrap this in a check.

```html
<p class="posted">Posted By: 
      <% if comment.user.present? %>
          <%= comment.user.username %>
      <% else %>
          Anonymous
      <% end %>
</p>
```


## Creating a user profile page

Adding a click through to a user profile

```html

<p class="posted">Posted By: 
    <% if comment.user.present? %>
        <%= link_to comment.user.username, user_path(comment.user) %>
    <% else %>
        Anonymous
    <% end %>
</p>

```

Users need a show function


```ruby

  #users controller
  def show

        @user = User.find(params[:id])
        
    end

```

UsersController#show is missing a template for request formats: text/html

Then we create a show.html.erb in views/users

```html

<h2><%= @user.username %></h2>

<p>Their email is <%= @user.email %></p>

```

add vanity url to users 

so we transform /users/2 to /users/jameswood

in users model

```ruby
def to_param
    username
end
```
  
in show action in users controller
change find to :username

```ruby
 def show

        @user = User.find_by(params[:username])

    end

```

## Removing actions

if the user isnt the logged in user

```html
<% if @review.user == @current_user %>
<div class="actions">
    <%= link_to "Edit this Review", edit_review_path(@review) %>
    <%= link_to "Delete Review", review_path(@review), method: :delete, data: { confirm: "Are you sure?" } %>
</div>
<% end %>
```

now a user cant edit a review that isnt theirs, however they can if they go to the /edit url to fix this we have to Authorise he controller action.


## Authorizing controlller actions

in #edit and #destroy and #update of reviews controller

```ruby
 def edit 
        # find the review to edit
        @review = Review.find(params[:id])
        
        if @review.user != @current_user
            redirect_to root_path
        end
    end
```

```ruby
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
```

```ruby
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
```


## Introducing bookmarks

A review has many bookmarks
A user has many bookmarks 
A user can only have one bookmark per review


## The bookmark model

generate bookmark model

```bash
rails generate model Bookmark review:belongs_to user:belongs_to
```

run the generated migration after checking

```bash
rails db:migrate
```

add has_many :bookmarks to review.rb and user.rb

then in bookmark.rb we want to make it so 1 user per review

[check rails validations](https://guides.rubyonrails.org/active_record_validations.html)

```ruby
class Bookmark < ApplicationRecord
  belongs_to :review
  belongs_to :user

  ###
  validates :review, uniqueness: { scope: :user }
  ###
end

```

## Creating bookmarks

Generate Bookmark Controller

```bash
rails generate controller bookmarks
```

in config/routes.rb

```ruby

resources :reviews do 
    resources :comments
    resource :bookmark
  end

```

in reviews show view

```
<% if is_logged_in? %>

   <p>
       <% link_to "Bookmark", review_bookmark_path(@review), method: :post %>
   </p>

<% end %>
```

This will now link to the bookmarks controller
so in the controller...

```ruby
class BookmarksController < ApplicationController

    before_action :check_login

    def create
        @review = Review.find(params[:review_id])

        @bookmark = @review.bookmarks.new
        @bookmark.user = @current_user

        @bookmark.save

        redirect_to review_path(@review)

    end

end
```

## Un-bookmarking

```html
<% if is_logged_in? %>
   <p>
        <% if @review.bookmarks.where(user: @current_user).any? %>
            <%= link_to "UnBookmark", review_bookmark_path(@review), method: :delete %>
        <% else %>
            <%= link_to "Bookmark", review_bookmark_path(@review), method: :post %>
        <% end %>
   </p>

<% end %>
```

```ruby
def destroy
      @review = Review.find(params[:review_id])

      @review.bookmarks.where(user: @current_user).delete_all

      redirect_to review_path(@review)
  end
```

## Listing all bookmarks

## Updating Heroku

## Homework


.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.

---
