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
  'US/Eastern',
  'UTC'
]

TRIGGER_MAP = {
  '#p' => 'US/Pacific',
  '#m' => 'US/Mountain',
  '#c' => 'US/Central',
  '#e' => 'US/Eastern'
}

def do_times(trigger, phrase)
  message = nil
  emoji = nil
  begin
    time = Chronic.parse(phrase)
    if time
      Time.zone = TRIGGER_MAP[trigger] || 'UTC'
      time = time.in_time_zone(Time.zone)
      puts "Parsed: #{phrase} #{trigger} -> #{time}"
      times = []
      TIME_ZONES.each do |zone|
        z = TZInfo::Timezone.get(zone)
        local_time = time.in_time_zone(z)
        times << "#{local_time.strftime('%I:%M%P')} #{local_time.zone}"
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
      message, emoji = do_times(params[:trigger], params[:phrase])
      status 200
      
      reply = { username: 'timelord', icon_emoji: emoji, text: message } 
      return reply.to_json
    end
    
    post "/time" do
      message, emoji = do_times(request['trigger_word'],request['text'])
      status 200
      
      reply = { username: 'timelord', icon_emoji: emoji, text: message } 
      return reply.to_json
    end
  end
end
