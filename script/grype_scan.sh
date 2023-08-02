 #!/bin/bash -xe
echo "Sourcing variables to get values of build_info.json" 
source variable.sh

if [ ${BUILD_DOCKER} == true ]; then
    wget https://github.com/anchore/grype/releases/download/v0.62.1/grype_0.62.1_linux_ppc64le.tar.gz
    tar -xf grype_0.62.1_linux_ppc64le.tar.gz
    chmod +x grype
    sudo mv grype /usr/bin

    sudo grype -q -s AllLayers -o cyclonedx-json ${imageName} > grype_sbom_results.json
    # curl -s -k -u ${env.dockerHubUser}:${env.dockerHubPassword} --upload-file grype_sbom_results.json ${url_prefix}/Grype_sbom_results.json

    sudo grype -q -s AllLayers -o json ${imageName} > grype_vulnerabilities_results.json
    
    cat grype_sbom_results.json
    cat grype_vulnerabilities_results.json
    # curl -s -k -u ${env.dockerHubUser}:${env.dockerHubPassword} --upload-file grype_vulnerabilities_results.json ${url_prefix}/Grype_vulnerabilities_results.json
fi
