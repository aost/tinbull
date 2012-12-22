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
    if topic.posts.length == 1
      topic.created_at
    else
      [topic.updated_at, topic.created_at].join(" \u2013 ")
    end
  end

  def page_section
    if !params[:section]
      "All sections"
    else
      '~'+params[:section]
    end
  end
end
