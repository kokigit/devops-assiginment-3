if ! [ -x "$(command -v docker)" ]; then
  sudo yum update -y
  sudo yum install -y git
  sudo yum install -y docker
  sudo service docker start
  sudo usermod -a -G docker ec2-user
fi

if ! [ -x "$(command -v docker-compose)" ]; then
  sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi

if cd devops-assiginment-3; then
  git pull
else 
  git clone https://github.com/kokigit/devops-assiginment-3.git
  cd devops-assiginment-3
fi

# remove all containers before run new image
docker stop $(docker ps -aq) 
docker rm $(docker ps -aq)

# run in background
docker-compose up -d
