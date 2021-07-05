#setup app config
/usr/local/bin/aws s3 cp s3://myapp-gitlab/app_vars.sh /opt/configs/app_vars.sh
chmod 700 /opt/configs/app_vars.sh

#setup app
/usr/local/bin/aws s3 cp s3://myapp-gitlab/app.tar.gz /tmp/app.tar.gz
tar -xzf /tmp/app.tar.gz -C /opt/app

#install app
cd /opt/app
python3 -m venv env
source env/bin/activate
pip install -r requirements.txt