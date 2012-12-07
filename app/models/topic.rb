class Topic < ActiveRecord::Base
  attr_accessible :name, :text

  validates :name, presence: true, length: { maximum: 120 }
  validates :text, length: { maximum: 5000 }
end
