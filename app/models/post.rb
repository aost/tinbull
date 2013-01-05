require 'digest'
require 'nokogiri'

class Post < ActiveRecord::Base
  attr_accessible :text, :password, :parent, :poster
  attr_reader :password

  belongs_to :topic, touch: true
  belongs_to :parent, class_name: "Post"
  has_many :children, class_name: "Post", foreign_key: "parent_id"
  belongs_to :poster, class_name: "User"
  has_and_belongs_to_many :flaggers, class_name: "User", 
    foreign_key: "flagged_post_id", association_foreign_key: "flagger_id"

  validates :text, presence: true, length: { maximum: 5000 }
  #validates :topic, presence: true # TODO: Add topic form doesn't work with this
  validates :password, length: { maximum: 128 }
  validates :poster, presence: true
  validate :poster_cannot_be_blocked

  after_create do
    self.topic = parent.topic if parent
    topic.reload
    self.sub_id = topic.posts.index self
    decimal_id = topic.password_hashes.index password_hash
    self.password_id = alphabase(decimal_id) if decimal_id
    save
  end

  def password= p
    if p && !p.empty?
      @password = p
      salt = ENV['PASSWORD_SALT'] || "salty"
      self.password_hash = Digest::SHA256.base64digest(salt + p) 
    else
      @password = self.password_hash = nil
    end
  end

  def html
    tinbullic_to_html(ERB::Util.html_escape(text))
  end

  def plain_text
    Nokogiri::HTML(html).text
  end

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

    # preserve urls
    urls = []
    html_text = text.gsub(/\w+:\/\/[\S]*/) do |m|
      urls << m
      "\uE001"
    end

    html_text.gsub!(/\*{2}(.+?)\*{2}/, '<b>\1</b>') # bold text
    html_text.gsub!(/\*{1}(.+?)\*{1}/, '<i>\1</i>') # italic text

    html_text.gsub!("\uE001") { |m| urls.shift } # restore urls
    named_links = []
    html_text.gsub!(/\[(.+?)\|(.+?)\]/) do |m| # named links 
      text = $1
      url = $2
      if !url.match(/^(\/|\w+:\/\/)/)
        url = "http://" + url
      end
      named_links << "<a href=\"#{url}\">#{text}</a>" # preserve
      "\uE002"
    end
    html_text.gsub!(/\w+:\/\/.+?\.\w{2,3}[^\s\.?!,)]*/, 
      '<a href="\0">\0</a>') # unnamed links
    html_text.gsub!("\uE002") { |m| named_links.shift } # restore named links

    # unordered lists
    html_text.gsub!(/^\*\s(.+)/, '<li>\1</li>')
    html_text.gsub!(/(<li>.*<\/li>)/m, '<ul>\1</ul>')
    
    # ordered lists
    html_text.gsub!(/^(\d+)\.\s(.*)/, '<li value="\1">\2</li>')
    html_text.gsub!(/(<li value.*<\/li>)/m, '<ol>\1</ol>')

    html_text.gsub!(/(.+?)((\r?\n){2}|\z)/m, '<p>\1</p>') # paragraphs
    # not around lists
    html_text.gsub!(/<p>(<(ul|ol)>.*<\/(ul|ol)>)<\/p>/m, '\1') 
    html_text
  end

  def poster_cannot_be_blocked
    if poster && poster.blocked == true
      if !poster.posts.empty?
        idn = poster.posts.last.id
      else
        idn = poster.id.to_s + 'P'
      end
      errors.add(:poster, "is barred from participating. If there has been a grave misunderstanding, please contact butiminnocent@tinbull.com with ID##{idn}.")
    end
  end
end
