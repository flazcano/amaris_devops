from flask import Flask, jsonify, make_response

app = Flask(__name__)


@app.route('/')
def hello_world():
    data_set = {"Hello": "World"}
    return make_response(jsonify(data_set), 200)


@app.route('/healthz')
def return_ok():
    return make_response("ok", 200)


if __name__ == '__main__':
    app.run()
