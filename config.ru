require './lib/app'

run Rack::Cascade.new [HangoutAddon::API,HangoutAddon::Web]
