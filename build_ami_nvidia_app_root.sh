#setup app user
useradd -c "MYAPP App User" -s /bin/bash -m MYAPP

#install utils
apt-get -y install python-pip python3-pip python3-venv nginx tree atop jq libpq-dev
pip3 install awscli

#setup gpumon
pip2 install nvidia-ml-py boto3
wget -q "https://s3.amazonaws.com/aws-bigdata-blog/artifacts/GPUMonitoring/gpumon.py" -O /usr/local/src/gpumon.py
sed -i "s/my_NameSpace = .*/my_NameSpace = 'MYAPP' /" /usr/local/src/gpumon.py
sed -i "s/sleep_interval = .*/sleep_interval = 60 /" /usr/local/src/gpumon.py
cat << EOF > /lib/systemd/system/gpumon.service
[Unit]
Description=GPU Monitor

[Service]
ExecStart=/usr/bin/python2.7 /usr/local/src/gpumon.py
Restart=on-failure
Type=simple

[Install]
WantedBy=default.target
EOF

#setup configs directory
mkdir /opt/configs
chown -R MYAPP:MYAPP /opt/configs
chmod -R 700 /opt/configs/

#setup api directory
mkdir /opt/app
chown MYAPP:MYAPP /opt/app

#setup api systemd unit 
cat << EOF > /lib/systemd/system/MYAPP.service
[Unit]
Description=MYAPP

[Service]
User=MYAPP
WorkingDirectory=/opt/app
ExecStart=/bin/bash /usr/local/src/start_app.sh
Restart=on-failure
Type=simple

[Install]
WantedBy=default.target
EOF

#setup NGINX
/usr/local/bin/aws s3 cp s3://MYAPP-gitlab/nginx.conf /etc/nginx/nginx.conf
/usr/local/bin/aws s3 cp s3://MYAPP-gitlab/app.conf /etc/nginx/conf.d/app.conf

nginx -t

#setup app
/usr/local/bin/aws s3 cp s3://MYAPP-gitlab/start_app.sh /usr/local/src/start_app.sh
chown MYAPP:MYAPP /usr/local/src/start_app.sh
chmod 700 /usr/local/src/start_app.sh

#setup cloudwatch agent
wget --quiet "https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb"
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
rm amazon-cloudwatch-agent.deb
aws s3 cp s3://MYAPP-gitlab/cloudwatch.json /opt/configs/cloudwatch.json
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/configs/cloudwatch.json -s

#turn on services
systemctl daemon-reload
systemctl enable MYAPP
systemctl enable gpumon
systemctl enable nginx
systemctl enable amazon-cloudwatch-agent