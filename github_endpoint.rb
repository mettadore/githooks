require 'sinatra'
require 'json'
require './slacker'

post '/payload' do
  push = JSON.parse(request.body.read)
  icon_url = 'https://upload.wikimedia.org/wikipedia/en/a/a6/Bender_Rodriguez.png'
  attachment = [{
            fallback: opts[:attach][:fallback] || 'Attachment',
            color: opts[:attach][:color] || 'good',
            text: opts[:attach][:text],
            pretext: opts[:attach][:pretext],
            fields: format_fields(opts[:attach][:fields])
        }]
  attachments = push.map do |k,v|
    {
      fallback: 'Attachment',
      color: 'good',
      text: k
      fields: v
    }
  Slack::Notifier.ping "Github Payload", icon_url: icon_url, attachments: attachments
end
