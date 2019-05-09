 node {
  def acr = 'myk8clusterreg001.azurecr.io'
  def appName = 'superduper'
  def imageName = "${acr}/${appName}"
  def imageTag = "${imageName}:${env.BRANCH_NAME}.${env.BUILD_NUMBER}"
  def appRepo = "myk8clusterreg001.azurecr.io/superduper:v0.0.1"

  checkout scm
  
 stage('Build the Image and Push to Azure Container Registry') 
 {
   app = docker.build("${imageName}")
   withDockerRegistry([credentialsId: 'dupa1_auth', url: "https://${acr}"]) {
      app.push("${env.BRANCH_NAME}.${env.BUILD_NUMBER}")
                }
  }

 stage ("Deploy Application on Azure Kubernetes Service")
 {
  switch (env.BRANCH_NAME) {
    // Roll out to canary environment
    case "canary":
        // Change deployed image in canary to the one we just built
        sh("sed -i.bak 's#${appRepo}#${imageTag}#' ./canary/*.yml")
        sh("kubectl --namespace=prod apply -f ./canary/")
        sh("echo http://kubectl --namespace=psrestapi-production get service/${appName} --output=json | jq -r '.status.loadBalancer.ingress[0].ip' > ${appName}")
        break

    // Roll out to production
    case "master":
        // Change deployed image in master to the one we just built
        sh("sed -i.bak 's#${appRepo}#${imageTag}#' ./production/*.yml")
        sh("kubectl --namespace=prod apply -f ./production/")
        sh("echo http://kubectl --namespace=psrestapi-production get service/${appName} --output=json | jq -r '.status.loadBalancer.ingress[0].ip' > ${appName}")
        break

    // Roll out a dev environment
    default:
        // Create namespace if it doesn't exist
        sh("kubectl get ns ${appName}-${env.BRANCH_NAME} || kubectl create ns ${appName}-${env.BRANCH_NAME}")
        // Don't use public load balancing for development branches
        sh("sed -i.bak 's#${appRepo}#${imageTag}#' ./dev/*.yml")
        sh("kubectl --namespace=${appName}-${env.BRANCH_NAME} apply -f ./dev/")
        echo 'To access your environment run kubectl proxy'
        echo "Then access your service via http://localhost:8001/api/v1/proxy/namespaces/${appName}-${env.BRANCH_NAME}/services/${appName}:80"     
    }
  }
}
