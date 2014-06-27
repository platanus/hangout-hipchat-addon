require 'open-uri'

require 'grape'
require 'sinatra'
require 'rack-flash'
require 'jwt'
require 'oauth2'
require 'haml'
require "sinatra/activerecord"

module HangoutAddon
  class Web < Sinatra::Base
  	register Sinatra::ActiveRecordExtension
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
