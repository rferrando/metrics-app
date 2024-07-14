bundle exec rails db:environment:set RAILS_ENV=test
bundle exec rails db:migrate RAILS_ENV=test
bin/rails test