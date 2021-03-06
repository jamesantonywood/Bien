class Review < ApplicationRecord

    # add an association that has a 1-to-many relationship
    has_many :comments

    # add an association for bookmarks
    has_many :bookmarks

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

