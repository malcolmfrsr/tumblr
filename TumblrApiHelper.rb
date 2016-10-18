module TumblrApiHelper

  def TumblrApiHelper.TUMBLR_INFO_LINK (user_name, api_key)
    return "http://api.tumblr.com/v2/blog/#{user_name}.tumblr.com/info?api_key=#{api_key}"
  end
  def TumblrApiHelper.TUMBLR_LIKED_POSTS_LINK (user_name, api_key, offset = 0)
    return "http://api.tumblr.com/v2/blog/#{user_name}.tumblr.com/likes?api_key=#{api_key}&limit=20&offset=#{offset}"
  end

end