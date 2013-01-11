class Topic < ActiveRecord::Base
  attr_accessible :name, :section, :posts_attributes

  has_many :posts, dependent: :destroy
  accepts_nested_attributes_for :posts

  validates :name, presence: true, length: { maximum: 120 }
  validates :section, presence: true, length: { maximum: 20 }
  validates_format_of :section, with: /\A[a-z0-9]*\Z/,
    message: "needs to be alphanumeric"

  after_create do
    section_topics = Topic.where(section: section)
    self.sub_id = section_topics.index(self) + 1
    save
  end 

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

  def popularity
    return nil if !id
    Rails.cache.fetch("/topic/#{id}-#{posts.count}/popularity", expires_in: 1.week) do
      Post.where('created_at >= ? AND topic_id = ?', 24.hours.ago, id).count
    end
  end
end
