wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get update
sudo apt-get -y install esl-erlang
sudo apt-get -y install elixir
sudo apt-get -y install nginx
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g bower
sudo apt-get install -y postgresql postgresql-contrib
MIX_ENV=prod mix ecto.create
sudo apt-get install inotify-tools
sudo apt-get install ruby
sudo gem install sass

sudo mkdir -p /app
sudo chown -R ubuntu:ubuntu /app

wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
./certbot-auto
./certbot-auto certonly
