require 'digest'

class Post < ActiveRecord::Base
  attr_accessible :text, :password

  belongs_to :topic, touch: true
  belongs_to :parent, class_name: "Post"
  has_many :children, class_name: "Post", foreign_key: "parent_id"

  def password= p
    if p
      # TODO: Implement real salt
      self.password_hash = Digest::SHA256.base64digest("salty" + p) 
    else
      self.password_hash = nil
    end
  end

  def poster_id
    decimal_id = topic.password_hashes.index password_hash
    alphabase(decimal_id) if decimal_id
  end

  validates :text, presence: true
  validates :topic, presence: true

  private

  def alphabase(n, letters = [])
    alphabet = ('A'..'Z').to_a
    length = alphabet.length
    if (n >= length)
      alphabase(n/length - 1, letters)
      n = n % length
    end
    letters << alphabet[n]
    letters.join
  end
end
