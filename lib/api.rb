module HangoutAddon
  class API < ::Grape::API
    format :json

    resource :hipchat do
      desc 'Recipient for new messages'
      post 'new_message' do
        message = params[:item][:message][:message] rescue 'Error trying to get message'

        if message =~ /vamos al hangout/
          room = params[:item][:room]
          room_name = room[:name]
          room_id = room[:id]

          account = Account.find_by hipchat_room_id: room_id

          client = HipChat::Client.new(account.hipchat_oauth_token, :api_version => 'v2')
          client[room_name].send('Hangout bot', 'I talk')
        end
        200
      end

      desc 'Describes the add-on and what its capabilities are'
      params do
        requires :account_id, type: String,
          desc: 'The account this add-on will be installed to'
      end
      get 'capabilities/:account_id' do
        {
          name: 'HangoutAddon',
          description: 'Adds hangout link to HipChat',
          key: 'us.platan.hipchat-addon',
          links: {
            homepage: ENV['BASE_URI'],
            self: "#{ENV['BASE_URI']}/hipchat/capabilities/#{params[:account_id]}"
          },
          vendor: {
            url: 'http://addon.platan.us',
            name: 'Platanus'
          },
          capabilities: {
            hipchatApiConsumer: {
              scopes: ENV['HIPCHAT_SCOPES'].split(' ')
            },
            configurable: {
              url: "#{ENV['BASE_URI']}/hipchat/configure/#{params[:account_id]}"
            },
            installable: {
              callbackUrl: "#{ENV['BASE_URI']}/hipchat/install/#{params[:account_id]}"
            }
          }
        }
      end

      desc 'Receive installation notification'
      params do
        requires :account_id, type: String,
          desc: 'Account that has installed the add-on'
      end
      post 'install/:account_id' do
        if account = Account.find_by_id(params[:account_id])
          # Update account
          account.hipchat_oauth_id = params[:oauthId]
          account.hipchat_oauth_secret = params[:oauthSecret]
          account.hipchat_installed = true
          account.hipchat_capabilities_url = params[:capabilitiesUrl]
          account.hipchat_room_id = params[:roomId]

          # Verify capabilities
          response = open(URI.parse(params[:capabilitiesUrl]))
          capabilities = JSON.parse(response.read)
          raise UnexpectedApplicationError if capabilities['name'] != 'HipChat'

          # Request an OAuth token
          token_url = capabilities['capabilities']['oauth2Provider']['tokenUrl']
          authorization_url = capabilities['capabilities']['oauth2Provider']['authorizationUrl']

          client = OAuth2::Client.new(
            account.hipchat_oauth_id,
            account.hipchat_oauth_secret,
            site: token_url,
            scope: ENV['HIPCHAT_SCOPES'],
            token_url: token_url,
            authorization_url: authorization_url
          )

          token = client.client_credentials.get_token({scope: ENV['HIPCHAT_SCOPES'] }).token
          account.hipchat_oauth_token = token

          account.save

          #Subscribe to room message
          response = ::HTTParty.post("https://api.hipchat.com/v2/room/{#{account.hipchat_room_id}}/webhook",
            :query => {
              :url => "#{ENV['BASE_URI']}/hipchat/new_message",
              :event => 'room_message',
              :name => 'Searching hangout'
            })

          response = response.parsed_response

          200
        else
          # Responding with error status will cause the installation to fail
          raise NoAccountError
        end
      end

      desc 'Receive uninstallation notification'
      params do
        requires :account_id, type: String,
          desc: 'Account that has removed the add-on'
        requires :oauth_id, type: String,
          desc: 'OAuth ID value for the installation'
      end
      delete 'install/:account_id/:oauth_id' do
        if account = Account.find(params[:account_id])
          account.hipchat_installed = false
          account.save
        else
          # Uninstallation will continue anyway, we just can't
          # track it to an account.
          raise NoAccountError
        end
      end
    end

  end
end
