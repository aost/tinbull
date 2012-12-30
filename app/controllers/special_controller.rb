class SpecialController < ApplicationController

  def sections
    @title = "Sections"
    sections = []
    Topic.where('created_at >= ?', 1.month).each { |t| sections << t.section }
    section_freq = sections.inject(Hash.new(0)) { |h, v| h[v] += 1; h }
    @sections = section_freq.keys.sort_by { |v| -section_freq[v] }
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
