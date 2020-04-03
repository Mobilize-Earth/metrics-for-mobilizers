FROM ruby:2.7.0-alpine

RUN apk update \
&& apk add build-base mariadb-dev sqlite-dev nodejs npm \
&& npm install yarn -g

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY startup.sh /app/startup.sh

RUN bundle install

COPY . /app
EXPOSE 3000

CMD ["sh", "./startup.sh" ]
