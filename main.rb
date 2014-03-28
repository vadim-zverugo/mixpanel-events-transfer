require 'mixpanel_client'
require 'json'
require 'yaml'
require 'pathname'
require './lib/string'

config = YAML.load_file('config.yml')
date_pattern = '%Y-%m-%d'

api_key = config['api_key']
raise 'api_key is required' if api_key.blank?

api_secret = config['api_secret']
raise 'api_secret is required' if api_secret.blank?

from_date_s = config['from_date']
raise 'from_date is required' if from_date_s.blank?
from_date = Date.strptime(from_date_s, date_pattern)
raise 'from_date is invalid (ex. 2014-02-22)' if from_date.nil?

to_date_s = config['to_date']
raise 'to_date is required' if to_date_s.blank?
to_date = Date.strptime(to_date_s, date_pattern)
raise 'to_date is invalid (ex. 2014-02-22)' if to_date.nil?

raise 'from_date cannot be after to_date' if from_date > to_date

mixpanel_client = Mixpanel::Client.new(api_key: api_key, api_secret: api_secret)
downloads_dir = Pathname.new(Dir.pwd).join('downloads')

from_date.upto(to_date) do |date|
  date_s = date.strftime(date_pattern)
  data = mixpanel_client.request(
      'export',
      from_date: date_s,
      to_date: date_s
  )
  filename = downloads_dir.join("data_#{date_s}.json")
  File.open(filename, 'wb') do |f|
    f.write(data.to_json)
  end
  puts "#{data.size} event(s) have been saved in #{filename}"
end
