class Topic < ActiveRecord::Base
  attr_accessible :name, :text, :section

  belongs_to :section

  def section= s
    case s
    when Section
      self.section_id = s.id
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
end
