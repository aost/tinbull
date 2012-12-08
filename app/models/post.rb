require 'bcrypt'

class Post < ActiveRecord::Base
  attr_accessible :text, :password

  def password= p
    if p
      # TODO: Implement real salt
      self.password_hash = BCrypt::Password.create("salty" + p) 
    else
      self.password_hash = nil
    end
  end

  validates :text, presence: true
end
