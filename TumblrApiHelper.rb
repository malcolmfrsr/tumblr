require 'httparty'

module TumblrApiHelper

  # Helper api calls : Need authentication to make requests see https://www.tumblr.com/docs/en/api/v2
  def TumblrApiHelper.TUMBLR_INFO_LINK (user_name, api_key)
    return "http://api.tumblr.com/v2/blog/#{user_name}.tumblr.com/info?api_key=#{api_key}"
  end

  def TumblrApiHelper.TUMBLR_LIKED_POSTS_LINK (user_name, api_key, offset = 0)
    return "http://api.tumblr.com/v2/blog/#{user_name}.tumblr.com/likes?api_key=#{api_key}&limit=20&offset=#{offset}"
  end

  def TumblrApiHelper.TUMBLR_BLOG_POSTS_LINK (user_name, api_key, type = 'photo', offset = 0)
    return "http://api.tumblr.com/v2/blog/#{user_name}.tumblr.com/posts/#{type}?api_key=#{api_key}&limit=20&offset=#{offset}"
  end

  # Helper methods
  def TumblrApiHelper.get_total_amount_of_posts(url, post_type = 'likes')
    response = HTTParty.get(url)
    parsed_response = JSON.parse(response.body)

    return parsed_response['response']['blog'][post_type]
  end

  def TumblrApiHelper.download_types(post)
    if (post['type']) != 'video'
      download_images(post['summary'], post['photos'])
    else
      download_videos(post['summary'], post['video_url'])
    end
  end

  def TumblrApiHelper.create_folder(folder)
    internal_create_folder(folder)
  end

  class << self
    private
    def internal_create_folder(folder)
      if File.directory?(folder)
        return
      else
        Dir.mkdir(folder)
      end
    end
  end

end