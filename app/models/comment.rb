class Comment < ActiveRecord::Base
	belongs_to :user
	belongs_to :status

	attr_accessible :body, :status_id, :user_id

	validates :user_id, :presence => true
	validates :status_id, :presence => true
 	validates :body, :presence => true, :length => { :maximum => 50000 }     # spam protection

 	default_scope :order => 'comments.created_at asc'
end
