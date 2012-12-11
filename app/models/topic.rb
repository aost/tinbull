class Topic < ActiveRecord::Base
  attr_accessible :name, :text, :section

  has_many :posts

  def text= t
    if t.blank?
      self[:text] = nil 
    else
      self[:text] = t
    end
  end

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

  validates :name, presence: true, length: { maximum: 120 }
  validates :text, length: { maximum: 5000 }
  validates :section, presence: true, length: { maximum: 16 }, 
                      format: { with: /\A[a-z0-9]+\Z/ } # lowercase alphanumeric
end
