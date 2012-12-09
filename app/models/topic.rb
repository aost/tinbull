class Topic < ActiveRecord::Base
  attr_accessible :name, :text, :section
  serialize :password_hashes, Array

  belongs_to :section
  has_many :posts

  def text= t
    if t.blank?
      self[:text] = nil 
    else
      self[:text] = t
    end
  end

  def section= s
    case s
    when Section
      super
    when String
      self.section_id = Section.where(name: s).first_or_create.id
    when nil
      self.section_id = nil
    else
      raise ActiveRecord::AssociationTypeMismatch, 
        "section field must be section reference or name"
    end
  end

  validates :name, presence: true, length: { maximum: 120 }
  validates :text, length: { maximum: 5000 }
  validates :section, presence: true

  before_save :generate_password_hashes

  def generate_password_hashes
    posts.each do |p|
      self.password_hashes << p.password_hash if p.password_hash
    end
    self.password_hashes.uniq!
  end
end
