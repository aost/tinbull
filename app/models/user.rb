class User < ActiveRecord::Base
  attr_accessible :ip

  validates :ip, presence: true, uniqueness: true
end
