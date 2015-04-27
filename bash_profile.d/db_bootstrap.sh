function db_bootstrap() {
  rake db:drop db:create db:migrate db:setup
}
