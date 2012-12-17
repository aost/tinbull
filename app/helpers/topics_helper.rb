module TopicsHelper
  def time_ago(topic)
    create_time = time_ago_in_words(topic.created_at)
    update_time = time_ago_in_words(topic.updated_at)
    if update_time != create_time
      "#{update_time} \u2013 #{create_time} ago"
    else
      "#{create_time} ago"
    end
  end

  def time(topic)
    [topic.updated_at, topic.created_at].uniq.join(" \u2013 ")
  end

  def page_section
    if !params[:section]
      "All topics"
    else
      '~'+params[:section]
    end
  end
end
