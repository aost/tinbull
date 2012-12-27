class Topic < ActiveRecord::Base
  attr_accessible :name, :section, :posts_attributes

  has_many :posts, dependent: :destroy
  accepts_nested_attributes_for :posts

  validates :name, presence: true, length: { maximum: 120 }
  validates :section, presence: true, length: { maximum: 20 }
  validates_format_of :section, with: /\A[a-z0-9]*\Z/,
    message: "has to be alphanumeric"
  validate :has_posts?

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

  def popularity
    return nil if !id
    today_posts = Post.where('created_at >= ?', 24.hours.ago).count
    return 0 if today_posts == 0
    topic_today_posts = 
      Post.where('created_at >= ? AND topic_id = ?', 24.hours.ago, id).count
    topic_today_posts/today_posts.to_f
  end

  private
  
  def has_posts?
    errors.add(:posts, "must have at least one post") if posts.empty?
  end
end
