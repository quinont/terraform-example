#/bin/bash

sudo apt-get update
sudo apt-get install -yq build-essential python-pip rsync
pip install flask

cat << EOF > /tmp/app.py
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_cloud():
  return '${MENSAJE}!'

app.run(host='0.0.0.0')
EOF

python /tmp/app.py
