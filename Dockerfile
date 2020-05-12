FROM ruby:2.7.0-alpine

RUN apk update \
&& apk add build-base mariadb-dev sqlite-dev nodejs npm \
&& npm install yarn -g

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY startup.sh /app/startup

RUN gem install sassc -- --disable-march-tune-native
RUN bundle install --without deployment test

COPY . /app

ARG RAILS_ENV

RUN yarn
RUN SECRET_KEY_BASE=1 RAILS_ENV=production rails assets:precompile

EXPOSE 3000

CMD ["sh", "./startup.sh" ]
