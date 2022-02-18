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
    title.parameterize
  end  
  #produces: 4-hello-world


```




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
