function migrate_development() {
  bundle exec rake db:migrate RAILS_ENV=development
}
