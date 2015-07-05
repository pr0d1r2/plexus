# Use app name as param to find defaults full name
function defaults_search() {
  defaults domains | tr ',' '\n' | grep -i $1
}
