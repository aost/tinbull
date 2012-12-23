class Topic < ActiveRecord::Base
  attr_accessible :name, :section, :posts_attributes

  has_many :posts, dependent: :destroy
  accepts_nested_attributes_for :posts

  validates :name, presence: true, length: { maximum: 120 }
  validates :section, presence: true, length: { maximum: 20 }, 
                      format: { with: /\A[a-z0-9]+\Z/ } # lowercase alphanumeric
  validate :has_posts?

  self.per_page = 20

  def section= s
    self[:section] = s.downcase
    if section[0] == '~'
      self[:section] = section[1..-1]
    end
  end

  def password_hashes
    hashes = []
    posts.each do |post|
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
