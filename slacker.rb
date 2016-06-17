require "faraday"
require "json"

class SlackerError < StandardError ; end


class Slacker

  def initialize(opts={})
    @hook_url ||= ENV['SLACK_WEBHOOK_URL']
    @channel = ENV['SLACK_CHANNEL']
  end

  def post(msg, attachments = [])
    send_payload channel: @channel, text: msg, attachments: attachments
  end

  def send_payload(payload)
    conn = Faraday.new(@hook_url) do |c|
      c.use(Faraday::Request::UrlEncoded)
      c.adapter(Faraday.default_adapter)
    end

    response = conn.post do |req|
      req.body = JSON.dump(payload)
    end

    handle_response(response)
  end

  def handle_response(response)
    unless response.success?
      if response.body.include?("\n")
        raise SlackerError
      else
        raise SlackerError.new(response.body)
      end
    end
  end
end
