# 3. Get your Toggl project Id doing in irb:
require 'json'
require 'togglv8'

config = JSON.parse(File.read('config.json'), symbolize_names: true)
toggl_token = config[:toggl_token]

toggl_api = TogglV8::API.new(toggl_token)
pid = toggl_api.get_time_entries.last['pid']

p "Last pid is: #{pid}"

# This last command assumes your last entry has the right project, otherwise you have to
# look for it using toggl_api.get_time_entries
