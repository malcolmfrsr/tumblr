# Install this the SDK with "gem install dropbox-sdk"
require 'dropbox_sdk'

# Get your app key and secret from the Dropbox developer website
APP_KEY = '5phwd9gtoljth3z'
APP_SECRET = '6gdlvbljkde8b45'

DropboxOAuth2FlowNoRedirect.new('5phwd9gtoljth3z', '6gdlvbljkde8b45')

flow = DropboxOAuth2FlowNoRedirect.new(APP_KEY, APP_SECRET)
authorize_url = flow.start()

# Have the user sign in and authorize this app
puts '1. Go to: ' + authorize_url
puts '2. Click "Allow" (you might have to log in first)'
puts '3. Copy the authorization code'
print 'Enter the authorization code here: '
code = 'E3b8i2V-sqQAAAAAAAAshAFQyWGrfKR7XAsoNhB3cZ8'

# This will fail if the user gave us an invalid authorization code
access_token, user_id = flow.finish(code)

client = DropboxClient.new(access_token)
puts "linked account:", client.account_info().inspect