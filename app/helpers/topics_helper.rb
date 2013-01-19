module TopicsHelper
  def time_ago(topic)
    created_time = time_ago_in_words(topic.created_at)
    updated_time = time_ago_in_words(topic.updated_at)
    if updated_time != created_time
      "#{updated_time} \u2013 #{created_time} ago"
    else
      "#{created_time} ago"
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

  # Make topic form errors make more sense.
  def fix_topic_error(error)
    error.gsub! "Posts ", ""
    error[0] = error[0].capitalize
    error.gsub! "Name", "Topic"
  end

  def other_posts_freshest_first(topic)
    posts = topic.posts.where(parent_id: nil).order('created_at DESC')
    posts[0..-2]
  end
end
