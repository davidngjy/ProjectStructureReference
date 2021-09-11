## Software to install
1. Visual Studio 2022
2. Microsoft SQL Management Studio 18
3. Docker Desktop with Kubernetes enabled (for deploying into local Kubernetes cluster)
4. Helm choco install kubernetes-helm (for deploying into local Kubernetes cluster)

## To Begin
- ./bootstrap-database.ps1 (Create two DB, Authorization and Management)
- ./generate-database-login.ps1 (Create login, add to env var and k8s secret)

## Deploy all applications to local k8s instance
1. In ./Applications folder, execute `docker-compose build`
    * Build all the docker images locally
2. Switch directory to ./HelmCharts/Applications
3. Execute `helm upgrade application-deployment . -f .\values.local.yaml --install --atomic --wait --debug`
    * Deploy helm chart using locally built image (note: values.local.yaml)

## Ongoing development
1. Bump the application respective tag version in docker-compose.yaml (same folder as the .sln)
2. Make sure ./Applictions/docker-compose.yaml is aligned with the same version (for local development)
3. Bump to the same version in ./HelmCharts/Applications/values.yaml (this result in deployment on CI/CD pipeline)