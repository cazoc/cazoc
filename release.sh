export MIX_ENV=prod

npm install
bower install
mix ecto.migrate
mix clean
mix deps.get --only prod
mix compile
mix phoenix.digest
mix release
