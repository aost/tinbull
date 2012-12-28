class User < ActiveRecord::Base
  attr_accessible :ip

  has_many :posts, foreign_key: "poster_id"
  has_and_belongs_to_many :flagged_posts, class_name: "Post", 
    foreign_key: "flagger_id", association_foreign_key: "flagged_post_id"

  validates :ip, presence: true, uniqueness: true
end
