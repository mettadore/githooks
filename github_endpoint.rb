require 'sinatra'
require 'json'
require 'slack-notifier'
require './octoclient'

def format_fields(fields)
  case fields
    when Array
      fields
    when Hash
      fields.map { |k, v| { title: k.to_s, value: v.to_s } }
    else
      [{ title: fields.class.name, value: fields.to_s }]
  end
end

post '/payload' do
  push = JSON.parse(request.body.read)
  icon_url = 'https://upload.wikimedia.org/wikipedia/en/a/a6/Bender_Rodriguez.png'
  slack = Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'])
  attachments = push.select {|k,_v| %w{action pull_request}.include?(k) }.map do |k, v|
    {
      fallback: 'Attachment',
      color: 'good',
      pretext: k,
      fields: format_fields(v)
    }
  end
  #if push[:action] == 'opened'
  #  && push[:pull_request].present?
  #  && push[:pull_request][:title].match(/QMS/)
  slack.ping "Github Payload", icon_url: icon_url, attachments: attachments
  #client = Octoclient.new(push[:repository][:full_name])
  #  client.label!(push[:pull_request][:number])

end
