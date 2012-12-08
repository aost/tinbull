class Section < ActiveRecord::Base
  attr_accessible :name

  has_many :topics

  def name= n
    self[:name] = n.downcase
  end

  validates :name, presence: true, length: { maximum: 16 }, 
                   format: { with: /\A[a-z0-9]+\Z/ }, # lowercase alphanumeric
                   uniqueness: true
end
