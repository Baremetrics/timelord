#ruby

require 'bundler/setup'
require 'sinatra'
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
  'Europe/London',
  'Europe/Madrid'
]

TRIGGER_MAP = {
  'US/Pacific' => %w(PDT PST PACIFIC P #P),
  'US/Mountain' => %w(MDT MST MOUNTAIN M #M),
  'US/Central' => %w(CDT CST CENTRAL C #C),
  'US/Eastern' => %w(EDT EST EASTERN E #E),
  'Europe/London' => %w(BST B #B),
  'Europe/Madrid' => %w(CEST CE #CE)
}

def do_times(phrase)
  message = nil
  emoji = nil
  begin
    zone_identifier = phrase.split.first.try(:upcase)
    zone_identifier = zone_identifier[1..99] if zone_identifier[0] == '#' 
    puts "ZONE: #{zone_identifier}"
    zone = 'UTC'
    if zone_identifier
      TRIGGER_MAP.keys.each do |key|
        if TRIGGER_MAP[key].include?(zone_identifier)
          zone = key
          break
        end
      end
    end
    
    Time.zone = zone
    Chronic.time_class = Time.zone
    time = Chronic.parse(phrase)
    if time
      puts "Parsed: #{phrase} -> #{time.strftime('%I:%M%P')} #{time.zone}"
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
      message, emoji = do_times(params[:text])
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
