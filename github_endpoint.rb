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
  attachments = push.select { |k, _v| %w{action pull_request}.include?(k) }.map do |k, v|
    {
      fallback: 'Attachment',
      color: 'good',
      pretext: k,
      fields: format_fields(v)
    }
  end
  slack.ping push[:action], icon_url: icon_url
  if push[:action] == 'opened' #&&
    #!push[:pull_request].nil? &&
    #push[:pull_request][:title].match(/QMS/)
    client = Octoclient.new(push[:repository][:full_name])
    string = "PR ##{push[:pull_request][:number]} #{push[:action]} and labeled '#{client.current_label_name}'"
    slack.ping string, icon_url: icon_url
    client.label!(push[:pull_request][:number])
  end
end
