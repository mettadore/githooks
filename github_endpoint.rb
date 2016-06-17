require 'sinatra'
require 'json'
require 'slack-notifier'

def format_fields(fields)
  case fields
    when Array
      fields
    when Hash
      fields.map { |k, v| {title: k.to_s, value: v.to_s} }
    else
      [fields]
  end
end

post '/payload' do
  push = JSON.parse(request.body.read)
  icon_url = 'https://upload.wikimedia.org/wikipedia/en/a/a6/Bender_Rodriguez.png'
  slack = Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'])
  attachments = push.map do |k,v|
    {
      fallback: 'Attachment',
      color: 'good',
      text: k,
      fields: format_fields(v)
    }
  end
  slack.ping "Github Payload", icon_url: icon_url, attachments: attachments
end
