#ruby

require 'bundler/setup'
require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'chronic'
require 'active_support/core_ext/time'
require 'active_support/core_ext/time/zones'
require 'active_support/core_ext/string'


TIME_ZONES = [
  'US/Pacific',
  'US/Mountain',
  'US/Central',
  'US/Eastern'
]

def do_times(phrase)
  message = nil
  emoji = nil
  begin
    Time.zone = "UTC"
    Chronic.time_class = Time.zone
    time = Chronic.parse(phrase)
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
    [message, emoji]
  rescue => e
    p e.message
    [nil, nil]
  end
end

module TimeBot
  class Web < Sinatra::Base

    before do
      return 401 unless request["token"] == ENV['SLACK_TOKEN']
    end

    get '/time' do
      message, emoji = do_times(params[:phrase])
      status 200
      
      reply = { username: 'timelord', icon_emoji: emoji, text: message } 
      return reply.to_json
    end
    
    post "/time" do
      message, emoji = do_times(request['text'])
      status 200
      
      reply = { username: 'timelord', icon_emoji: emoji, text: message } 
      return reply.to_json
    end
  end
end
