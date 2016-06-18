require 'json'
require 'octokit'
require 'pry'
require './slacker'

class Octoclient
  attr_accessor :client
  def initialize(repo=nil)
    @client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
    @repo = repo || 'mettadore/githooks'
  end

  def labels
    @client.labels(@repo)
  end
  def add_label(issue)
    @client.add_labels_to_an_issue(@repo, issue, current_label_name)
  end
  def current_labels(issue)
    @client.labels_for_issue(@repo, issue)
  end
  def label(issue)
    current_labels.detect{|l| l[:name] == current_label_name }
  end
  def label!(issue)
    label = label(issue)
    label ||= add_label
    label[:name]
  end

  def current_label_name
    version_date.strftime('%y.%-m.%-d')
  end

  def current_due_date
    version_date.to_time.iso8601
  end

  def version_date
    Date.today - Date.today.wday + 9
  end

  def color_from_date
    '#dedede'
  end

end

c = Octoclient.new
binding.pry
blah = 'blah'
