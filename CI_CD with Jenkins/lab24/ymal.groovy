def call(String deploymentFile, String registry, String username, String imageName, String tag) {
    sh "sed -i 's|image:.*|image: ${registry}/${username}/${imageName}:${tag}|g' ${deploymentFile}"
}
