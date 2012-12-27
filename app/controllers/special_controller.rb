class SpecialController < ApplicationController

  def sections
    @title = "Sections"
    @sections = []
    Topic.all.each { |t| @sections << t.section }
    @sections.uniq!
  end

  def about
    @title = "About"
  end

  def markup
    @title = "Markup"
  end

  def code
    redirect_to "https://github.com/skofo/tinbull"
  end
end
