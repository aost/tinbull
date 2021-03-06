class Topic < ActiveRecord::Base
  attr_accessible :name, :section, :posts_attributes

  has_many :posts, dependent: :destroy
  accepts_nested_attributes_for :posts

  validates :name, presence: true, length: { maximum: 120 }
  validates :section, presence: true, length: { maximum: 20 }
  validates_format_of :section, with: /\A[a-z0-9]*\Z/,
    message: "needs to be alphanumeric"

  after_create do
    section_topics = Topic.where(section: section).order('id ASC')
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
    Rails.cache.fetch("topic_password_hashes_#{id}_#{posts.count}") do
      hashes = []
      posts.order('id ASC').each do |post|
       hashes << post.password_hash
      end
      hashes.delete(nil)
      hashes.uniq
    end
  end

  def popularity
    return nil if !id
    Rails.cache.fetch("topic_popularity_#{id}_#{updated_at}", expires_in: 1.hour) do
      Post.where('created_at >= ? AND topic_id = ?', 24.hours.ago, id).count
    end
  end
end
