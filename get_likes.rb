require File.join File.dirname(__FILE__), 'TumblrLikeDownloader'

apiKey = '24cbpXp3Vbva3g86cWuzppF8gE6rqTHSxaAtMk4AkfOzFNXiuJ'
userName = ARGV[0].nil? && 'malcolmfrsr' ||  ARGV[0]
folder = ARGV[1].nil? && 'likes' ||  ARGV[1]

puts "This is the user name #{userName} and the folder name #{folder}"

tumblr_likes = Tumblr_like_downloader.new(apiKey, folder, userName)
tumblr_likes.download