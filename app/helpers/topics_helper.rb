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
end
