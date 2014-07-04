class Hipchat
  attr_accessor :token

  def initialize(token)
    @token = token
  end

  def suscribe_to(room_id, event, callback_url)
    json_body = JSON.generate({
      :url => callback_url,
      :event => 'room_message',
      :name => 'Searching hangout'
    })

    response = ::HTTParty.post("https://api.hipchat.com/v2/room/#{account.hipchat_room_id}/webhook?auth_token=#{@token}",
                               :body => json_body,
                               :headers => {'Content-Type' => 'application/json'})
  end

  def send_message(room_name, message)
    json_body = JSON.generate({ message: message})

    response = ::HTTParty.post("https://api.hipchat.com/v2/room/#{room_name}/notification?auth_token=#{@token}",
                               :body => json_body,
                               :headers => {'Content-Type' => 'application/json'})
  end

end
