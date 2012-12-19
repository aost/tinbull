require 'digest'

class Post < ActiveRecord::Base
  attr_accessible :text, :password

  belongs_to :topic, touch: true
  belongs_to :parent, class_name: "Post"
  has_many :children, class_name: "Post", foreign_key: "parent_id"

  def text= t
    self[:text] = tinbullic_to_html(t)
  end

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

  def tinbullic_to_html(text)
    return text if text.blank? # require text

    # monospace text
    text.gsub!(/^\s{2}(.*?)$/, '<pre>\1</pre>')
    # preserve monospace text
    monotext = []
    text.gsub!(/<pre>.*?<\/pre>/) do |m| 
      monotext << m
      "\uE000"
    end

    # preserve urls
    urls = []
    text.gsub!(/\w+:\/\/[\S]*/) do |m|
      urls << m
      "\uE001"
    end

    text.gsub!(/\/(.+?)\//, '<i>\1</i>') # italic text
    text.gsub!(/\*(.+?)\*/, '<b>\1</b>') # bold text
    text.gsub!(/_(.+?)_/, '<u>\1</u>') # underlined text

    text.gsub!("\uE001") { |m| urls.shift } # restore urls
    named_links = []
    text.gsub!(/\[(.+?)\|(.+?)\]/) do |m| # named links 
      named_links << "<a href=\"$2\">$1</a>" # preserve
      "\uE002"
    end
    text.gsub!("\uE002") { |m| named_links.shift }

    # unordered lists
    text.gsub!(/\*\s(.+)/, '<li>\1</li>')
    text.gsub!(/(<li>.*<\/li>)/m, '<ul>\1</ul>')
    
    # ordered lists
    text.gsub!(/(\d+)\.\s(.*)/, '<li value="\1">\2</li>')
    text.gsub!(/(<li value.*<\/li>)/m, '<ol>\1</ol>')

    text.gsub!(/(.+?)(\n{2}|\z)/m, '<p>\1</p>') # make paragraphs
    text.gsub!("\uE000") { |m| monotext.shift } # restore monospace text

    text
  end
end
