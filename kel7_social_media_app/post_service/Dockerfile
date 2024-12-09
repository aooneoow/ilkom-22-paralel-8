# Gunakan image Ruby
FROM ruby:3.2

# Install dependensi sistem
RUN apt-get update -qq && apt-get install -y build-essential libsqlite3-dev

# Set working directory
WORKDIR /usr/src/app

# Salin file Gemfile dan Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Instalasi dependensi Ruby
RUN bundle install

RUN mkdir -p tmp/pids

# Salin semua kode aplikasi ke dalam image
COPY . .

# Expose port aplikasi
EXPOSE 9292

# Perintah untuk menjalankan aplikasi
CMD ["puma", "-C", "puma.rb"]
