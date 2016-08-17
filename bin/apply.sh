cd /app
sudo cp ~/cazoc/rel/cazoc/releases/0.2.1/cazoc.tar.gz /app/
sudo tar xfz cazoc.tar.gz
sudo chown -R ubuntu:ubuntu /app
sudo restart cazoc
sudo service nginx restart
