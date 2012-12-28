class User < ActiveRecord::Base
  attr_accessible :ip

  has_many :posts, foreign_key: "poster_id"

  validates :ip, presence: true, uniqueness: true
end
