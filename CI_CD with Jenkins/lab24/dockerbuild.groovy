def call(String dockerfile, String imageName, String tag, String registry, String username, String password) {
    sh "docker build -f ${dockerfile} -t ${registry}/${username}/${imageName}:${tag} ."
}
