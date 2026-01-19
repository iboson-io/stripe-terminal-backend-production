FROM ruby:3.1.2-alpine

RUN apk add build-base
RUN gem install bundler:2.3.24
RUN mkdir -p /www/example-terminal-backend
WORKDIR /www/example-terminal-backend
COPY . .
RUN bundle install
EXPOSE 4567

# Support PORT environment variable (for platforms like Heroku, Render)
# Default to 4567 if PORT is not set
ENTRYPOINT ["sh", "-c", "ruby web.rb -p ${PORT:-4567} -o 0.0.0.0"]
