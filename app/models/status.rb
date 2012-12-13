class Status < ActiveRecord::Base
	belongs_to :user
	has_many :comments, :dependent => :destroy
	has_many :ratings, :dependent => :destroy
	
	attr_accessible :content, :user_id

	validates :content, presence: true,
	                  length: { minimum: 2 }
	validates :user_id, presence: true

	# returns the number of ratings for that article
	def count_ratings
	  self.ratings.all.count
	end

	# returns the average rating for that article
	def avg_rating
	  @avg = self.ratings.average(:stars)     
	  @avg ? @avg : 0
	end
end