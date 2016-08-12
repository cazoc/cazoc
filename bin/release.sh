npm install
bower install
mix deps.get --only prod
MIX_ENV=prod mix ecto.migrate
MIX_ENV=prod mix clean
MIX_ENV=prod mix compile
mkdir priv/static
MIX_ENV=prod mix phoenix.digest
MIX_ENV=prod mix release

# cd /app
# tar the new release
# sudo chown -R ubuntu:ubuntu /app
