#!/bin/bash

# A pipeline script for Amaris/Falabella
## ----------------------------------
# Step #1: Define variables
# ----------------------------------
RED='\033[0;41;30m'
YLW='\033[0;0;33m'
GRN='\033[0;0;32m'
STD='\033[0;0;39m'
FLASK_IMAGE_GZIPED=flask-hello-world_latest.tar.gz
K8S_NAMESPACE=default

# ----------------------------------
# Step #2: User defined function
# ----------------------------------
pause(){
  read -p "Press [Enter] key to continue..." fackEnterKey
}

build(){
  echo "${GRN}Building...${STD}"
  skaffold build
}

unit(){
  echo "${GRN}Running unit tests${STD}"
  prepare_env
  python -m pytest
}

package(){
  echo "${GRN}Saving image in $FLASK_IMAGE_GZIPED${STD}"
  docker save flask-hello-world:latest -o $FLASK_IMAGE_GZIPED
  echo "${GRN}done${STD}"
}

deploy(){
  # kubectl -n$K8S_NAMESPACE apply -f k8s/flask-app_deployment.yml
  # kubectl -n$K8S_NAMESPACE apply -f k8s/flask-app_service.yml
  # kubectl -n$K8S_NAMESPACE apply -f k8s/flask-app_ingress.yml
  echo "${GRN}Installing ingress${STD}"
  install_ingress
  echo "${GRN}Deploying components${STD}"
  skaffold run
  echo "${GRN}open http://localhost${STD}"
}

smoke(){
  echo "${YLW}No smoke tests yet...${STD}"
}

prepare_env(){
  source venv/bin/activate
#  pip install -r requirements.txt
}

check_k8s_env(){
  kubectl cluster-info
  kubectl -n$K8S_NAMESPACE get deploy,pod,svc,ing -owide
}

check_deploy(){
  FLASK_APP_IP=$(kubectl get svc helm-flask-hello-world -o jsonpath="{.spec.clusterIP}")
  FLASK_APP_PORT=$(kubectl get svc helm-flask-hello-world -o jsonpath="{.spec.port}")
  echo "${GRN}If ingress is enabled, you can get access with${STD}"
  echo "curl http://localhost"
  echo "${GRN}else${STD}"
  echo "kubectl -n$K8S_NAMESPACE run curl-flask-app --image=radial/busyboxplus:curl -i --tty --rm -- /usr/bin/curl http://$FLASK_APP_IP"
  exit 0
}

install_ingress(){
#  helm repo add nginx-stable https://helm.nginx.com/stable
#  helm repo update
  helm install my-ingress ingress-nginx/ingress-nginx
}

set_k8s_ns(){
  local namespace
  read -p "Enter namespace" namespace
  K8S_NAMESPACE=$namespace
}

# function to display menus
show_menus() {
	clear
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo " DEPLOYER"
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Build Docker image"
	echo "2. Run test unit"
	echo "3. Package the image"
	echo "4. Deploy in current K8s cluster"
	echo "5. Run smoke tests"
	echo "6. Check cluster status"
	echo "7. Check deployment"
	echo "8. Install ingress"
	echo "9. Set cluster namespace"
	echo "0. Exit"
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
	local choice
	read -p "Enter choice [0 - 9] " choice
	case $choice in
		1) build && pause ;;
		2) unit && pause ;;
		3) package && pause ;;
		4) deploy && pause ;;
    5) smoke && pause ;;
    6) check_k8s_env && pause ;;
    7) check_deploy && pause ;;
		8) install_ingress && pause ;;
		9) set_k8s_ns && pause ;;
		0) exit 0;;
		*) echo "${RED}Error in selection...${STD}" && sleep 3
	esac
}

# ----------------------------------------------
# Step #3: Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP


# -----------------------------------
# Step #4: Main logic - infinite loop
# ------------------------------------
while true
do

	show_menus
	read_options
done