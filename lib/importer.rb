require 'mixpanel_client'
require 'json'
require 'base64'

class Importer
  def initialize(api_key, api_secret, token)
    @api_key = api_key
    @token = token
    @client = Mixpanel::Client.new(api_key: api_key, api_secret: api_secret, parallel: true)
  end

  def import(events, extra_properties = {})
    requests = []
    events.each do |event|
      # set additional event properties
      event['properties']['token'] = @token unless event['properties'].has_key?('token')
      extra_properties.each do |key, value|
        event['properties'][key] = value unless event['properties'].has_key?(key)
      end
      # prepare parallel requests
      request = @client.request('import', {
          data: Base64.encode64(event.to_json),
          api_key: @api_key
      })
      requests.push(request)
    end

    @client.run_parallel_requests

    imported_n = 0
    requests.each do |request|
      imported_n += 1 if request.response.handled_response == [1]
    end
    puts "#{imported_n} from #{events.size} event(s) have been imported"
  end
end