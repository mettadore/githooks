require 'sinatra'
require 'json'
require './slacker'

post '/payload' do
  push = JSON.parse(request.body.read)
  Slacker.new "I got some JSON", push.inspect
end
