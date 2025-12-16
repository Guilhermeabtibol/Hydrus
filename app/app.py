import socket
from flask import Flask, render_template
import datetime

app = Flask(__name__)

@app.route('/')
def home():
    hostname = socket.gethostname()
    hostname = socket.gethostname()
    server_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return render_template('index.html',
		          server_time=server_time,
                          owner="gvoxx")

app.route('/health')
def health():
    return {'status': 'healthy', 'timestamp' : datetime.datetime.now().isoformat()}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
