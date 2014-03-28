require 'mixpanel_client'

class Exporter
  def initialize(api_key, api_secret)
    @client = Mixpanel::Client.new(api_key: api_key, api_secret: api_secret)
  end

  def export(from, to, downloads_dir)
    # TODO: implement
  end
end