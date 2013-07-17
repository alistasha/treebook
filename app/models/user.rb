class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :profile_name
  # attr_accessible :title, :body

  validates :first_name,    presence: true
  validates :last_name,     presence: true
  validates :profile_name,  presence: true,
                            uniqueness: true,
                            format: {
                              with: /^[a-zA-Z0-9_-]+$/,
                              message: "Must be formatted correctly."
                            }

  has_many :statuses
  has_many :comments, :dependent => :destroy
  has_many :ratings, :dependent => :destroy
  # Since a user can have more than 1 friend, we're going to use a has_many association. 
  has_many :user_friendships
  has_many :friends, through: :user_friendships

  def full_name
  	first_name + " " + last_name
  end

  def to_param
    profile_name
  end

  # The URL for our Gravatar Avatar
  def gravatar_url
    # Creating a stripped email equals email.strip.
    # It takes the string which is email, and the strip method removes any spaces before or after the text
    stripped_email = email.strip
    # We can do our downcased email equals our stripeed email.downcase
    # That will make everything lowercased.
    downcased_email = stripped_email.downcase
    # Then all we need to do is create our hash.
    # So our hash is going to be donw with the MD5 algorithm, 
    # and the way we access that is through the Digest::MD5.hexdigest(downcased_email)
    hash = Digest::MD5.hexdigest(downcased_email)

    # All we need to do is return the Gravatar URL which is at http://gravatar.com/avatar/hash
    # In Ruby this will replace this entire sequence here with whatever the value of hash is.
    # Because it's the last expression in our method it will return it as the value.
    "http://gravatar.com/avatar/#{hash}"
  end
end
