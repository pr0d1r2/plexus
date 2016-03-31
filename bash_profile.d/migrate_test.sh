function migrate_test() {
  bundle exec rake db:migrate RAILS_ENV=test
}
