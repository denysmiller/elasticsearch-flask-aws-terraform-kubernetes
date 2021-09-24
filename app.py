from flask import Flask, jsonify, request  
from elasticsearch import Elasticsearch, NotFoundError  

app = Flask(__name__)  

es = Elasticsearch(['http://elasticsearch:9200'])  

@app.route('/api/index', methods=['POST'])  
def index_document():  
    data = request.json  
    es.index(index='demo-index', id=data['id'], document=data)  
    return jsonify({"result": "Document indexed", "id": data['id']}), 201  

@app.route('/api/get/<id>', methods=['GET'])  
def get_document(id):  
    try:  
        document = es.get(index='demo-index', id=id)  
        return jsonify(document['_source']), 200  
    except NotFoundError:  
        return jsonify({"error": "Document not found"}), 404  

if __name__ == '__main__':  
    app.run(host='0.0.0.0', port=5000)  