wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get update

sudo apt-get install -y esl-erlang
sudo apt-get install -y elixir

sudo apt-get install -y nginx

curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g bower

sudo apt-get install -y postgresql postgresql-contrib

MIX_ENV=prod mix ecto.create

sudo apt-get install -y inotify-tools
sudo apt-get install -y ruby
sudo gem install sass

sudo apt-get install -y haskell-platform
sudo apt-get install -y pandoc

sudo wget https://github.com/jgm/pandoc/releases/download/1.17.2/pandoc-1.17.2-1-amd64.deb
sudo dpkg -i pandoc-1.17.2-1-amd64.deb

sudo mkdir -p /app
sudo chown -R ubuntu:ubuntu /app
