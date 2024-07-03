# Use the official Ruby image as a base image
FROM ruby:2.7

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set an environment variable to avoid installing gems in a shared location
ENV BUNDLE_PATH /gems

# Set the working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock
COPY Gemfile ./
COPY Gemfile.lock ./

# Install the gem dependencies
RUN gem install bundler -v 2.4.22 && bundle install

# Copy the rest of the application code
COPY . .

# Add a script to be executed every time the container starts
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Expose port 3000 to the Docker host
EXPOSE 3000

# The main command to run the Rails server
CMD ["rails", "server", "-b", "0.0.0.0", "--pid=/tmp/server.pid"]
