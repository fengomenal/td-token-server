FROM ruby:3.0.2-alpine
  
ADD Gemfile /app/

WORKDIR /app

RUN apk add --no-cache build-base ruby ruby-dev && \
        gem install bundler

RUN bundle install

ADD . /app

CMD ["ruby", "server.rb", "-o", "0.0.0.0"]]
