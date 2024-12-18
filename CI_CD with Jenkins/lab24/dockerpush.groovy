def call(String imageName, String tag, String registry, String username, String password) {
    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
        sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
    }
    sh "docker push ${registry}/${username}/${imageName}:${tag}"
}
