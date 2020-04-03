# Climate Movement Reporting Tool

It will allow local chapters to input relevant data and enable the centralized collection, reporting, and communication of the overall impact of decentralized climate movements.

# Install

```bash
git clone git@gitlab.com:climate-movement-reporting-tool/climate-movement-reporting-tool.git
```
# Dependencies
 ```
  Install rbenv and use Ruby 2.7.0 : https://github.com/rbenv/rbenv
  Install MySQL 8.0.19
 ```
# Set up

```bash
  #run these cmds in working directory
  gem install bundler # needed to download gems
  bundle install # install gems set in Gemfile

  #set local db username and password/or add the ENV variable to your bash/zsh file
  export DATABASE_HOST="localhost"
  export DATABASE_USERNAME="your_db_user"
  export DATABASE_PASSWORD="your_db_password"

  #create db
  rake db:create
```
# Starting up Rails

```
  rails s

  #Go to http://localhost:3000/
```

# Tests

## rSpec

```.bash
#run all tests
bundle exec rspec

#run unit tests
bundle exec rspec spec/unit

#run integration tests
bundle exec rspec spec/features
```

## Cucumber

```.bash
bundle exec cucumber
```

## Test that everything's ok

```bash
bundle exec rspec spec/canary_spec.rb
bundle exec cucumber features/canary.feature
```
