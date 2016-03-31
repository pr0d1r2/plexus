function migrate_cucumber() {
  bundle exec rake db:migrate RAILS_ENV=cucumber
}
