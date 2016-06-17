require 'sinatra'
require 'json'
require './slacker'

post '/payload' do
  push = JSON.parse(request.body.read)
  icon_url = 'https://upload.wikimedia.org/wikipedia/en/a/a6/Bender_Rodriguez.png'
  attachments = push.map do |k,v|
    {
      fallback: 'Attachment',
      color: 'good',
      text: k,
      fields: v
    }
  end
  Slack::Notifier.ping "Github Payload", icon_url: icon_url, attachments: attachments
end
