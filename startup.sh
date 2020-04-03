#! /bin/sh

#Stop existing running server
rm -f tmp/pids/server.pid

# If the database exists, migrate. Otherwise setup (create and migrate)
bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:create db:migrate
echo "Done!"

rails server -b 0.0.0.0
