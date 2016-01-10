FROM joshwlewis/docker-heroku-phoenix:latest

# Compile elixir files for production
ENV MIX_ENV prod

# This prevents us from installing devDependencies
ENV NODE_ENV production

# This causes brunch to build minified and hashed assets
ENV BRUNCH_ENV production

# We add manifests first, to cache deps on successive rebuilds
COPY ["mix.exs", "mix.lock", "/app/user/"]
RUN mix deps.get

# Again, we're caching node_modules if you don't change package.json
ADD package.json /app/user/
RUN npm install

# Add the rest of your app, and compile for production
ADD . /app/user/
RUN mix compile \
    && brunch build \
    && mix phoenix.digest
