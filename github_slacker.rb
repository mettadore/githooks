require 'json'
require 'octokit'
require './slacker'

class GithubSlacker

  def initialize
    @client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
    @slacker = Slacker.new
  end

  def run
    post @client.organizations.map{|b| b[:hooks_url]}.to_s
  end

  def post(text, title='Github Slacker')
    @slacker.post title, text
  end
end

#GithubSlacker.new.run
