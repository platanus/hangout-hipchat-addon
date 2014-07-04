require 'httparty'

class Hipchat
  attr_accessor :token

  def initialize(token)
    @token = token
  end

  def suscribe_to(room_id, opts = {})
    json_body = JSON.generate(opts)

    response = ::HTTParty.post("https://api.hipchat.com/v2/room/#{room_id}/webhook?auth_token=#{@token}",
                               :body => json_body,
                               :headers => {'Content-Type' => 'application/json'})
    data = JSON.parse(response)
    data["id"]
  end

  def cancel_suscription(room_id, hook_id)
    response = ::HTTParty.delete("https://api.hipchat.com/v2/room/#{room_id}/webhook/#{hook_id}?auth_token=#{@token}",
                               :headers => {'Content-Type' => 'application/json'})
  end

  def send_message(room_name, message)
    json_body = JSON.generate({ message: message})

    response = ::HTTParty.post("https://api.hipchat.com/v2/room/#{room_name}/notification?auth_token=#{@token}",
                               :body => json_body,
                               :headers => {'Content-Type' => 'application/json'})
  end

end
