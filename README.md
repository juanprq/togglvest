## Togglvest

Tool to sync time entries from [Toggl](toggle.com) to [Harvest](harvestapp.com)

### How to use it

1. Clone repo
2. Open `config.json` and set **all** the values (info on how to get those values can be found inside the files)
3. Run `bundle install`
4. Run `ruby sync_harvest.rb` whenever you want to sync your Toggl entries with Harvest
5. Enter your Harvest password and hit enter
6. Select the days before today to sync from Toggl (being 0 = today)

#### Notes
*  The script will add all the entries from Toggl to Harvest, so if you run it twice there will be duplicate records. You will have to manually delete them
*  If you add entries near midnight, they could be reported on Harvest for the next day
*  You must push every day your entries. Some bug with harvest prevent from pushing entries for days before.

#### Thanks
Thanks to @sanrodari a.k.a _Chez Piñeiro_ for the improvements!


