export MIX_ENV=prod

npm install
bower install
mix ecto.migrate
mix clean
mix deps.get --only prod
mix compile
mkdir priv/static
mix phoenix.digest
mix release

# cd /app
# tar the new release
# sudo chown -R ubuntu:ubuntu /app
