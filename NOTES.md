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

in: _''_

```html
<%= link_to "Delete Review", review_path, method: :delete, data: {confirm: "Are
you sure?"} %>
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
