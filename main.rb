require 'mixpanel_client'
require 'yaml'
require 'pathname'
require './lib/string'
require './lib/exporter'

config = YAML.load_file('config.yml')

api_key = config['api_key']
raise 'api_key is required' if api_key.blank?

api_secret = config['api_secret']
raise 'api_secret is required' if api_secret.blank?

from_date = config['from_date']
raise 'from_date is required' if from_date.blank?
from_date = Date.strptime(from_date, Exporter::DATE_PATTERN)
raise 'from_date is invalid (ex. 2014-02-22)' if from_date.nil?

to_date = config['to_date']
raise 'to_date is required' if to_date.blank?
to_date = Date.strptime(to_date, Exporter::DATE_PATTERN)
raise 'to_date is invalid (ex. 2014-02-22)' if to_date.nil?

raise 'from_date cannot be after to_date' if from_date > to_date

downloads_dir = Pathname.new(Dir.pwd).join('downloads')
mixpanel_exporter = Exporter.new(api_key, api_secret)
mixpanel_exporter.export(from_date, to_date, downloads_dir)