 #!/bin/bash -xe
echo "Sourcing variables to get values of build_info.json" 
source variable.sh

if [ ${BUILD_DOCKER} == true ]; then
    wget https://github.com/quay/clair/releases/download/v4.6.1/clairctl-linux-ppc64le
    wget https://raw.githubusercontent.com/quay/clair/main/local-dev/clair/config.yaml
    sudo cp clairctl-linux-ppc64le /usr/bin/clairctl
    sudo chmod +x /usr/bin/clairctl
    sudo yum install openssl -y
    sudo openssl s_client -showcerts -connect 163.69.91.4:2005 &>> /dev/null | openssl x509 -outform PEM > ca.crt
    sudo mkdir -p /etc/docker/certs.d/163.69.91.4/
    sudo cp ca.crt /etc/docker/certs.d/163.69.91.4/ca.crt
    sudo cp ca.crt /etc/ssl/certs/ca-certificates.crt

    sudo clairctl  report --host env.CLAIR_CONTAINER_HOST -o json ${IMAGE_NAME} > clair_vulnerabilities_results.json
    cat clair_vulnerabilities_results.json 
    # curl -s -k -u ${env.dockerHubUser}:${env.dockerHubPassword} --upload-file clair_vulnerabilities_results.json ${url_prefix}/clair_vulnerabilities_results.json
fi
