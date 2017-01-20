#Introduction

This script loads avation weather data from Weather Underground into a set of tables in MySQL.

# Installation

1. Copy the scripts to a directory that a user who has access to MySQL can run it from. 
2. Change `import_weather.sh` and `import_yesterdays_weather.sh` to executable by the user who will run them.
3. Setup the `mysql` commmand such that it can run without any options. When run it should be able to create tables and import data.
4. Run `import_weather.sh` to initally load older weather data into the database.
5. Schdule `import_yesterdays_weather.sh` to run daily via cron to update the database.