# Falabella Test DevOps

## Infra
- 1 Local machine (macOS Big Sur)
- Docker running locally (20.10.0)
- Kubernetes running locally (1.9.3), using default namespace for deployment, and Nginx for ingress

## App (Python Rest with Flask)
- Create a Hello World app with **Python + Flask**
  - For this test, I create a new Flask project with PyCharm (PyCharm 2020/3 and Python 3.9.1 in a virtual environment)
- The default application test make a route in **/** and return **Hello World** when it’s consumed by a get request over http
  - Create another route for k8s automated health checks
- Create a **Docker image**, with an official **Python image** (in this moment the current Python 3 minor version is 3.9.1)
- Create a **Helm chart** with requested definitions
  - **Scale** 2 pods
  - Define **health check**
  - Configure service with **ClusterIP**
- Install and configure **ingress**

## Deployment
- Define a pipeline for diferent stages 
  - I use **skaffold** for automate deployment process, and make a consistent definitions, with well know implementation
    - First, need to define the context for deployments
      - skaffold config set -k $(kubectl config current-context) local-cluster true
    - And run dev for a hot-reload changes in the app
      - skaffold dev
    - Or install the app in the cluster
      - skaffold run
- For operate pipeline script, I used/modded a simple script that consider all stages

## Considerations
- All deployment components was defined in k8s manifests and helm charts, but helm have more complete scope
- I invested 4-6 hours (from zero to refinement of definitions, process, resources, etc.), but have previous knowledge
- The deployer (deployment script) was modified for specific need, and the plan was create a Python deployer program, with a deep integration with Docker, Kubernetes, Helm, Skaffold...

## References
- https://medium.com/@mukherjee.aniket/continuous-development-using-skaffold-with-local-kubernetes-cluster-with-hot-reload-61009e185258
- https://github.com/anikm1987/skaffold-kubernetes/blob/master/python_app_k8s/flask_app_deployment.yaml
- https://docs.bitnami.com/tutorials/create-your-first-helm-chart/
- https://hub.docker.com/_/python
- https://www.opcito.com/blogs/local-kubernetes-development-simplified-with-skaffold/
- https://bash.cyberciti.biz/guide/Menu_driven_scripts
- https://github.com/po5i/flask-mini-tests
- https://apisyouwonthate.com/blog/health-checks-for-rest-grpc-apis-kubernetes-and-beyond
- https://medium.com/avmconsulting-blog/how-to-perform-health-checks-in-kubernetes-k8s-a4e5300b1f9d


