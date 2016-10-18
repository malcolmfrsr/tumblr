require 'httparty'
require File.join File.dirname(__FILE__), 'TumblrApiHelper'

apiKey = '24cbpXp3Vbva3g86cWuzppF8gE6rqTHSxaAtMk4AkfOzFNXiuJ'
blogname = 'the-dodo'
folder = 'blog_backup'
type = 'video'

class Tumblr_blog_downloader

  def initialize(api_key, folder, type, user_name)
    # members
    @api_key = api_key
    @folder = folder
    @user_name = user_name
    @url = TumblrApiHelper.TUMBLR_INFO_LINK(user_name, api_key)
    @generic_name = 0
    @type = type

    create_folder(@folder)
  end

  def create_folder(folder)
    if File.directory?(folder)
      return
    else
      Dir.mkdir(folder)
    end
  end

  def download

    amount_of_posts = TumblrApiHelper.get_total_amount_of_posts(@url, post_type = 'posts')
    download_all_blog_posts(amount_of_posts)
  end

  def download_all_blog_posts(posts_left_to_download, offset = 0)
    blog_posts = get_blog_posts(@user_name, @api_key, @type, offset)
    count_posts = 0

    if posts_left_to_download > blog_posts.length
      blog_posts.each do |post|

        count_posts += 1
        puts count_posts + offset
        puts post['summary']

        download_types(post)
      end
      offset += count_posts
      download_all_blog_posts(posts_left_to_download - count_posts, offset)
    else
      blog_posts.each do |post|

        count_posts += 1
        puts count_posts + offset
        puts post['summary']

        download_types(post)
      end
      puts 'We should be done'
    end
  end

  def download_types(post)
    if (post['type']) != 'video'
      download_images(post['summary'], post['photos'])
    else
      download_videos(post['summary'], post['video_url'])
    end
  end

  def get_total_amount_of_posts(url, post_type = 'likes')
    response = HTTParty.get(url)
    parsed_response = JSON.parse(response.body)

    return parsed_response['response']['blog'][post_type]
  end

  def get_blog_posts(user_name, api_key, type = 'photos', offset)
    url = TumblrApiHelper.TUMBLR_BLOG_POSTS_LINK(user_name, api_key, type, offset)
    response = HTTParty.get(url)
    parsed_response = JSON.parse(response.body)

    return parsed_response['response']['posts']
  end

  def download_images(subfolder, photos)
    clean_subfolder_path = subfolder.gsub(/[\x00\:\/\*\n\*\?\"<>\ \t|]/, '_')[0, 40]

    if clean_subfolder_path.nil? || clean_subfolder_path.empty?
      @generic_name += 1
      clean_subfolder_path = @generic_name
    end

    path = "#@folder/#{clean_subfolder_path}"
    create_folder(path)
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
      sub_folder = create_folder(path)
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

tumblr_blog = Tumblr_blog_downloader.new(apiKey, folder, type, blogname)
tumblr_blog.download

