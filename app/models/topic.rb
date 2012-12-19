class Topic < ActiveRecord::Base
  attr_accessible :name, :section

  has_many :posts
  accepts_nested_attributes_for :posts

  validates :name, presence: true, length: { maximum: 120 }
  validates :section, presence: true, length: { maximum: 20 }, 
                      format: { with: /\A[a-z0-9]+\Z/ } # lowercase alphanumeric
  validate :has_posts?

  self.per_page = 25

  def section= s
    self[:section] = s.downcase
  end

  def password_hashes
    hashes = []
    Post.find_each do |post|
     hashes << post.password_hash
    end
    hashes.delete(nil)
    hashes.uniq
  end

  def sub_id
    section_topics = Topic.where(section: section)
    section_topics.index(self) + 1
  end

  private
  
  def has_posts?
    errors.add(:posts, "must have at least one post") if posts.empty?
  end
end
