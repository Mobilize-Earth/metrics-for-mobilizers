# Metrics for Mobilizers  
  
**Metrics for Mobilizers** is a project of Mobilize Earth created in response to climate mobilization organizers' needs for more powerful, yet anonymous, reporting on the effectiveness of their activities. The tool was built to help movement leaders understand the impact of organizers' efforts through chapter-level reporting and visualizing collected data. 

We are now in a fight for all life on our planet. No one is prepared to face this alone and no one should.  Mobilize Earth is setting out on a new course to bring together people from all walks of life—industry, activists, politicians, farmers, immigrants—to respond to the climate and ecological emergency.

## Local Environment Setup
  
  ### Clone Repository with SSH
  
```bash  
git clone git@github.com:Mobilize-Earth/metrics-for-mobilizers.git  
```  

  ### IDE
  We recommend using [RubyMine](https://www.jetbrains.com/ruby/).
  
### Install/Configure Dependencies  
  
#### *rbenv* ([what is this?](https://github.com/rbenv/rbenv)) and Ruby 2.7.0
Install rbenv
```
brew install rbenv
```    
 Set up rbenv in your shell
```
rbenv init
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
```
 Install Ruby 2.7.0
```
rbenv install 2.7.0
```
Check your Ruby version
 ```
ruby -v 
#ruby 2.7.0p0 (2019-12-25 revision 647ee6f091) [x86_64-darwin18]
 ```

#### MySQL 8.0.19
Install MySQL 8.0.19 on [MacOS](https://dev.mysql.com/doc/refman/8.0/en/osx-installation-pkg.html)
Install MySQL 8.0.19 on [Windows](https://dev.mysql.com/doc/refman/8.0/en/windows-installation.html)
Install MySQL 8.0.19 on [Linux](https://dev.mysql.com/doc/refman/8.0/en/linux-installation-debian.html)

  
### Install Gems  
Download gems
```
gem install bundler
``` 
Install gems in the project's Gemfile
```
bundle install
```
If you get an error installing MySql2 during bundle install try running

```
bundle config --local build.mysql2 "--with-ldflags=-L/usr/local/opt/openssl/lib --with-cppflags=-I/usr/local/opt/openssl/include"
and doing a second bundle install
```

### Configure local database
Set your local database username and password or add the ENV variables to your bash/zsh file with correct credentials:

```
export DATABASE_HOST="localhost" 
export DATABASE_USERNAME="your_db_user" 
export DATABASE_PASSWORD="your_db_password"  
```
**Optional:** If you don't want to add variables to your path, you can use the `setup-local-env.sh` with your database credentials and run: 
```
source setup-local-env.sh
# this script also suppresses unnecessary Rails warnings
```

Create local database in MySQL and user with permissions:
```
mysql -u root -p<root_password> 
	- CREATE USER 'your_db_user'@'localhost' IDENTIFIED BY 'your_db_password';
	- CREATE DATABASE climate_movement_reporting_tool_development;
	- GRANT ALL ON climate_movement_reporting_tool_development.* TO 'your_db_user'@'localhost';
``` 
 Create database in Rails (only needed when you set up the app for the first time):
``` 
rake db:create db:migrate 
```
Seed database:
```
rake db:seed
```  
When there are changes to the database run:
```
rake db:migrate
```

 ### Install Frontend Dependencies 
 ```
 yarn  
 ``` 
  
## Locally run the app
  
  Start Rails server
```  
 rails s  
 # Go to http://localhost:3000/
 ```  

### Configuring emails in development and staging mode
Please update ```app/mailers/mail_development_interceptor.rb``` with your email address or testing emails in development and staging.

#### Rails Console
The `console` command lets you interact with your Rails application from the command line. To open your Rails console run:
```
rails c
```
 

## Tests  
### Update test database
Before running tests you may need to migrate the database to make sure it's up to date. Do this by running:
```
rails db:migrate RAILS_ENV=test
```

### rSpec  / Running tests
  
**Note:** Capybara uses the same port as the rails server so you'll need to shut that off before running the integration tests.

Run all tests  
```
bundle exec rspec  
```
  
Run unit tests  
```
bundle exec rspec spec/unit 
``` 
  
Run integration tests  
```
bundle exec rspec spec/features  
``` 
Run canary tests to make sure tests are working  
```bash  
bundle exec rspec spec/canary_spec.rb  
bundle exec cucumber features/canary.feature  
```  
#### Run tests in RubyMine
[Instructions]([https://blog.jetbrains.com/ruby/2018/10/running-tests-in-rubymine/](https://blog.jetbrains.com/ruby/2018/10/running-tests-in-rubymine/))

#### Coverage
Running rspec generates `coverage/index.html`. Open this in your browser to view a coverage report. The report shows tables detailing the number of lines per file and the percentage of lines covered by tests. Focus on expanding test coverage of files with many lines and low coverage.
