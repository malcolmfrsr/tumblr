require File.join File.dirname(__FILE__), 'TumblrBlogDownloader'

apiKey = '24cbpXp3Vbva3g86cWuzppF8gE6rqTHSxaAtMk4AkfOzFNXiuJ'
blogname = ARGV[0].nil? && 'malcolmfrsr' ||  ARGV[0]
type = ARGV[1].nil? && 'photo' ||  ARGV[1]
folder = ARGV[2].nil? && 'photo' ||  ARGV[2]

puts "This is the user name #{blogname} and the folder name #{folder}"

tumblr_blog = Tumblr_blog_downloader.new(apiKey, folder, type, blogname)
tumblr_blog.download