require 'open-uri'

require 'grape'
require 'sinatra'
require 'rack-flash'
require 'jwt'
require 'mongo_mapper'
require 'oauth2'
require 'haml'

configure do
  MongoMapper.setup({
    ENV['RACK_ENV'] => { 'uri' => ENV['MONGHQ_URL']}
  }, ENV['RACK_ENV'])
end

module HangoutAddon
  class Web < Sinatra::Base
    enable :sessions
    enable :logging

    use ::Rack::Flash

    set :session_secret, ENV['SESSION_SECRET']


  end
end

require './lib/models/account'
require './lib/exceptions'
require './lib/api'
require './lib/web'
