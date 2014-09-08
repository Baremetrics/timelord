#ruby

require 'bundler/setup'
require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'json'

module CatBot
  class Web < Sinatra::Base

    before do
      return 401 unless request["token"] == ENV['SLACK_TOKEN']
    end

    post "/cat" do
      @cats = []
      begin
        url = 'http://thecatapi.com/api/images/get?format=xml&size=med&results_per_page=1'
        doc = Nokogiri::HTML(open(url))
        doc.css('url').each do |kitty|
          @cats << kitty.content
        end
      rescue => e
        p e.message
        halt
      end
      status 200
      reply = { username: 'catapi', icon_emoji: ':cat2:', text: @cats.first }
      return reply.to_json
    end
  end
end
