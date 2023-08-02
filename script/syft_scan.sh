 #!/bin/bash -xe
echo "Sourcing variables to get values of build_info.json" 
source variable.sh

if [ ${BUILD_DOCKER} == true ]; then
    wget https://github.com/anchore/syft/releases/download/v0.60.3/syft_0.60.3_linux_ppc64le.tar.gz
    tar -xf syft_0.60.3_linux_ppc64le.tar.gz
    chmod +x syft
    sudo mv syft /usr/bin

    sudo syft -q -s AllLayers -o cyclonedx-json ${IMAGE_NAME} > syft_sbom_results.json
    cat syft_sbom_results.json
    #curl -s -k -u ${env.dockerHubUser}:${env.dockerHubPassword} --upload-file syft_sbom_results.json ${url_prefix}/Syft_sbom_results.json
fi
