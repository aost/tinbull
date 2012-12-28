module TopicsHelper
  def time_ago(topic)
    first_post_time = time_ago_in_words(topic.posts[0].created_at)
    last_post_time = time_ago_in_words(topic.posts[-1].created_at)
    if last_post_time != first_post_time
      "#{last_post_time} \u2013 #{first_post_time} ago"
    else
      "#{first_post_time} ago"
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
end
