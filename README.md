```
pip install -r requirements.txt  

terraform init  
terraform apply  

kubectl apply -f k8s-deployment.yaml  
kubectl port-forward service/flask-app 5000:5000  

POST http://localhost:5000/api/index - indexing document
GET http://localhost:5000/api/get/{id} - get document by id
```