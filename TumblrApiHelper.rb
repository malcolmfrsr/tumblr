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

    def download_images(subfolder, photos)
      clean_subfolder_path = subfolder.gsub(/[\x00\:\/\*\n\*\?\"<>\ \t|]/, '_')[0, 40]

      if clean_subfolder_path.nil? || clean_subfolder_path.empty?
        @generic_name += 1
        clean_subfolder_path = @generic_name
      end

      path = "#@folder/#{clean_subfolder_path}"
      internal_create_folder(path)
      puts "To path #{path}"
      if photos.respond_to?(:each)
        photos.each do |image|
          download_file_to_folder(path, image['original_size']['url'])
        end
      end
    end

    def download_videos(subfolder, video_path)
      if video_path.nil?
        puts 'No relevant content.'
      else
        clean_subfolder_path = subfolder.gsub(/[\x00\:\/\*\n\*\?\"<>\ \t|]/, '_')[0, 40]

        path = "#@folder/#{clean_subfolder_path}"
        internal_create_folder(path)
        puts "To path #{path}"
        download_file_to_folder(path, video_path)
      end
    end

    def download_file_to_folder(folder, url)
      file_name = File.basename(url)
      puts "Downloading . . . #{file_name}"
      puts "To path #{folder}"

      File.open("#{folder}/#{file_name}", "wb") do |f|
        f.binmode # @MariusButuc's suggestion
        f.write HTTParty.get(url).parsed_response
        f.close
      end
    end
  end

end