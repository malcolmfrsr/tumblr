require 'httparty'

apiKey = "24cbpXp3Vbva3g86cWuzppF8gE6rqTHSxaAtMk4AkfOzFNXiuJ"
userName = "malcolmfrsr"
folder = "my_like_backups"

class TumblrLikeDownloader

  # initialise
  def initialize(api_key, folder, user_name)
    # define the members
    @api_key = api_key
    @folder = folder
    @user_name = user_name

    @url = "http://api.tumblr.com/v2/blog/#{user_name}.tumblr.com/info?api_key=#{api_key}"

    # create the folder
    createFolder(@folder)
  end

  # create folder
  def createFolder(folder)
    if File.directory?(folder)
      return
    else
      Dir.mkdir(folder)
    end
  end

  # download
  def download

    like_count = getLikedCount(@url)

    download_all_liked_posts(like_count)
  end

  def download_all_liked_posts(likes_left_to_download, likes_downloaded = 0)
    # Tumblr api only allows for the loading of 20 liked posts at a time

    liked_posts = get_likes(@user_name, @api_key, likes_downloaded)
    count_downloads = 0
    if likes_left_to_download > liked_posts.length
      liked_posts.each do |post|
        puts post['summary']
        download_files(post['photos'])
        count_downloads += 1
        puts count_downloads + likes_downloaded
      end
      # call recursive here
      likes_downloaded += count_downloads
      download_all_liked_posts(likes_left_to_download - count_downloads, likes_downloaded)
    else
      liked_posts.each do |post|
        puts post['summary']
        download_files(post['photos'])
        count_downloads += 1
        puts count_downloads + likes_downloaded
      end
      puts "We should be done"
    end


  end

  # get the liked count
  def getLikedCount(url)
    response = HTTParty.get(url)
    parsed_response = JSON.parse(response.body)

    return parsed_response['response']['blog']['likes']
  end

  # get liked content
  def get_likes (user_name, api_key, offset = 0)
    url = "http://api.tumblr.com/v2/blog/#{user_name}.tumblr.com/likes?api_key=#{api_key}&limit=20&offset=#{offset}"
    response = HTTParty.get(url)
    parsed_response = JSON.parse(response.body)

    return parsed_response['response']['liked_posts']
  end

  def download_files(photos)
    if photos.respond_to?(:each)
      photos.each do |image|
        # Download the image
        download_file_to_folder(@folder, image['original_size']['url'])
      end
    end
  end

  # download files
  def download_file_to_folder(folder, url)
    file_name = File.basename(url)
    puts "Downloading . . . #{file_name}"

    File.open("#{folder}/#{file_name}", "wb") do |f|
      f.binmode # @MariusButuc's suggestion
      f.write HTTParty.get(url).parsed_response
      f.close
    end
  end

end


tumblr_likes = TumblrLikeDownloader.new(apiKey, folder, userName)
tumblr_likes.download

