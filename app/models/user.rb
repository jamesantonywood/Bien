class User < ApplicationRecord

    has_many :reviews
    has_many :comments
    has_many :bookmarks

    # Run has_secure_password
    has_secure_password

    # Validate username
    validates :username, presence: true, uniqueness: true

    # Validates email
    validates :email, presence: true, uniqueness: true

    # We dont need to validate real_name becuase it is an optional field

    def to_param
        username
    end

end
