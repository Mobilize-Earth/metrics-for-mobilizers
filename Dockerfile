FROM ruby:2.7.0-alpine

RUN apk update \
&& apk add build-base mariadb-dev sqlite-dev nodejs npm \
&& npm install yarn -g

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY startup.sh /app/startup.sh

RUN gem install sassc -- --disable-march-tune-native
RUN bundle install

COPY . /app
EXPOSE 3000

CMD rm -f tmp/pids/server.pid && bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:create db:migrate &&
