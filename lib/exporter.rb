require 'mixpanel_client'
require 'json'

class Exporter
  DATE_PATTERN = '%Y-%m-%d'

  def initialize(api_key, api_secret)
    @api_key = api_key
    @client = Mixpanel::Client.new(api_key: api_key, api_secret: api_secret)
  end

  def export(from, to, downloads_dir)
    from.upto(to) do |date|
      date_str = date.strftime(DATE_PATTERN)
      puts "Exporting events for the #{date_str}"
      data = @client.request('export', from_date: date_str, to_date: date_str)
      filename = downloads_dir.join("#{@api_key}_events_#{date_str}.json")
      File.open(filename, 'wb') { |f| f.write(data.to_json) }
      puts "#{data.size} event(s) have been exported into #{filename}"
    end
  end
end