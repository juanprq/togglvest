require 'date'
require 'togglv8'
require 'harvested'
require 'io/console'

config = JSON.parse(File.read('config.json'), symbolize_names: true)

harvest_subdomain = config[:harvest_subdomain]
harvest_username = config[:harvest_username]
harvest_project_id = config[:harvest_project_id]
harvest_task_id = config[:harvest_task_id]

p 'Type your Harvest password'
harvest_password = STDIN.noecho(&:gets).chomp

p 'How many days before?'
days_before = gets.chomp.to_i

toggl_token = config[:toggl_token]
toggl_project_id = config[:toggl_project_id]

####### HOW TO USE
# *  At the end of the day just run:
#    ruby sync_harvest.rb

####### NOTES
# *  The script will add all the entries from Toggl to Harvest, so if you run it twice there will be
#    duplicate records. You will have to manually delete them
# *  If you add entries near midnight, they could be reported on Harvest for the next day
# *  You must push every day your entries. Some bug with harvest prevent from pushing entries for days
#    before.

######## MAIN PROGRAM

p 'Getting toggl entries'
toggl_api = TogglV8::API.new(toggl_token)
start_date = (Date.today - days_before).to_time.iso8601
end_date = (Date.today - (days_before - 1)).to_time.iso8601
project = toggl_api.get_project(toggl_project_id)['name']
toggl_time_entries = toggl_api.get_time_entries(
  start_date: start_date,
  end_date: end_date
)

harvest = Harvest.hardy_client(
  subdomain: harvest_subdomain,
  username: harvest_username,
  password: harvest_password
)

p 'Creating harvest entries'
toggl_time_entries.each do |time_entry|
  entry = Harvest::TimeEntry.new(
    project_id: harvest_project_id,
    task_id: harvest_task_id,
    created_at: time_entry['start'],
    notes: "#{project} #{time_entry['description']}",
    hours: (time_entry['duration'].to_f / 3_600),
    spent_at: Date.parse(time_entry['start']).strftime('%d/%m/%Y')
  )

  harvest.time.create(entry, nil)
end
