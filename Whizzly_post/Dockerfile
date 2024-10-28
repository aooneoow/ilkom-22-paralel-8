FROM ruby:3.2-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000 50051

CMD ["bundle", "exec", "rackup", "-p", "3000", "-o", "0.0.0.0"]

