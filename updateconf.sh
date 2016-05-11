sudo cp cazoc.conf /etc/init/cazoc.conf
sudo cp cazoc /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/cazoc /etc/nginx/sites-enabled
sudo service nginx restart
