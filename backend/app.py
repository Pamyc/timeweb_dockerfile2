from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/hello')
def hello():
    return jsonify(msg='Привет из Flask!', ok=True)

@app.route('/health')
def health():
    return 'ok', 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
