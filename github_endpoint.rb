require 'sinatra'
require 'json'
require 'slack-notifier'

post '/payload' do
  push = JSON.parse(request.body.read)
  icon_url = 'https://upload.wikimedia.org/wikipedia/en/a/a6/Bender_Rodriguez.png'
  slack = Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'])
  attachments = push.map do |k,v|
    {
      fallback: 'Attachment',
      color: 'good',
      text: v.class,
      fields: v
    }
  end
  slack.ping "Github Payload", icon_url: icon_url, attachments: attachments
end
