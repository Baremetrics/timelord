#ruby

require 'bundler/setup'
require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'chronic'
require 'active_support/core_ext/time'
require 'active_support/core_ext/time/zones'
require 'active_support/cort_ext/string'


TIME_ZONES = [
  'US/Pacific',
  'US/Mountain',
  'US/Central',
  'US/Eastern'
]


module Time
  class Web < Sinatra::Base

    before do
      return 401 unless request["token"] == ENV['SLACK_TOKEN']
    end

    post "/time" do
      message = nil
      emoji = nil
      begin
        Time.zone = "UTC"
        Chronic.time_class = Time.zone
        time = Chronic.parse(request['text'])
        if time
          times = []
          TIME_ZONES.each do |zone|
            z = TZInfo::Timezone.get(zone)
            times << time.in_time_zone(z).strftime('%I:%M%P')
          end
          message = "> #{times.join(' | ')}"
          h = time.strftime('%I')
          h = h[1] if h.start_with?('0')
          emoji = ":clock#{h}:"
        end
      rescue => e
        p e.message
        halt
      end
      status 200
      
      reply = { username: 'timelord', icon_emoji: emoji, text: message } 
      return reply.to_json
    end
  end
end
