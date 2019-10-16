# Exercise 3: Deploying to OpenShift with Appsody

In this exercise, we will show how to deploy the sample insurance quote application built in [Exercise 2](/workshop/exercise-2/README.md) to OpenShift using Appsody. Appsody is an open source project that provides the following tools you can use to build cloud-native applications:

When you have completed this exercise, you will understand how to:

* deploy the applications to OpenShift using the appsody CLI

In later exercises we will learn how to use appsody with a Tekton pipeline, hooked to git, to trigger an automated deployment.

## Prerequisites

You should have already carried out the prerequisites defined in [Exercise 0](/workshop/exercise-0/README.md), and in addition:

* In order for the backend application to access the Dacadoo Health Score API, visit <https://models.dacadoo.com/doc/> to request an API key for evaluation purposes. Access to this API is granted individually to insurance professionals. There is a mock implementation of the API in the code that you can use if you do not want to register.

## Steps

1. [Set up a project namespace](#1-Set-up-a-project-namespace)
1. [Deploy the backend application to OpenShift](#2-deploy-the-backend-application-to-OpenShift)
1. [Deploy the frontend application to OpenShift](#3-deploy-the-frontend-application-to-OpenShift)

## 1. Set up a project namespace

OpenShift applications are deployed within a project. So the first step is to create a new project:

``` bash
$ oc new-project insurance-quote
Now using project "insurance-quote" on server "https://c100-e.us-east.containers.cloud.ibm.com:31718".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app centos/ruby-25-centos7~https://github.com/sclorg/ruby-ex.git

to build a new example application in Ruby.
```

Check that the current context is your team’s project space.

``` bash
$ oc project -q
insurance-quote
```

### 2. Deploy the backend application to OpenShift

We will use the `appsody deploy` command for the deployments.  This command:

* builds a deployment image for production usage (i.e. it does not include development-mode tools)
* pushes the image to your designated image registry
* builds a deployment yaml file (if you have not generated one already), as a CR for the Appsody Operator
* applies the yaml file to your Kubernetes cluster

Appsody has the ability to deploy directly to a kubernetes cluster using a default deployment manifest. This will work if the cluster does not require any specific credentials. In this case, we will need to provide these, so appsody allows you to generate the deployment manifest it would have used, but without doing the actual deployment. We can then modify this, and then ask appsody to use it for the deployment of our applications.

In order to have the backend application sends requests to the Dacadoo Health Score API, we need to create a secret that contains the configuration for making requests to the Dacadoo server. (Note: If you do not want to use the Dacadoo Health Score API, you can skip this setup and continue to use the mock endpoint.)

```bash
oc create configmap dacadoo-secret --from-literal=url=<url> --from-literal=apikey=<apikey>
```

where:

* `<url>` is the URL of the Dacadoo server (usually `https://models.dacadoo.com/score/2`)
* `<apikey>` is the API key that you obtained when you registered to use the API.

for example:

```bash
$ oc create configmap dacadoo-secret --from-literal=DACADOO_URL=https://models.dacadoo.com/score/2 --from-literal=DACADOO_APIKEY=Y3VB...RMGG
configmap/dacadoo-secret created
```

Navigate to your `quote-backend` directory. We need to modify the deployment yaml to pass the secret's values to the application. The initial deployment yaml can be generated as follows.

```bash
appsody deploy --generate-only
```

This creates a file named `app-deploy.yaml` in your project.

```yaml
apiVersion: appsody.dev/v1beta1
kind: AppsodyApplication
metadata:
  name: quote-backend
spec:
  # Add fields here
  version: 1.0.0
  applicationImage: dev.local/quote-backend
  stack: java-spring-boot2
  service:
    type: NodePort
    port: 8080
    annotations:
      prometheus.io/scrape: 'true'
      prometheus.io/path: '/actuator/prometheus'
  readinessProbe:
    failureThreshold: 12
    httpGet:
      path: /actuator/health
      port: 8080
    initialDelaySeconds: 5
    periodSeconds: 2
  livenessProbe:
    failureThreshold: 12
    httpGet:
      path: /actuator/liveness
      port: 8080
    initialDelaySeconds: 5
    periodSeconds: 2
  expose: true
  createKnativeService: false
```

We need to add a section to the generated file. Under the `spec` key, create a new `envFrom` key that has the value of your OpenShift config map. `dacadoo-secret` was used as the name in this workshop.

> **TIP**: Ensure there are two spaces before `name`, see <https://github.com/kubernetes/kubernetes/issues/46826#issuecomment-305728020>

```yaml
apiVersion: appsody.dev/v1beta1
kind: AppsodyApplication
metadata:
  name: quote-backend
spec:
  # Add fields here
  version: 1.0.0
  .
  .
  envFrom:
    - configMapRef:
        name: dacadoo-secret
  expose: true
  createKnativeService: false
```

At this point we're almost ready to push the image to the registry and deploy it to the cluster. In order to push the image we need make sure we are logged in to the image registry first.

```bash
docker login
```

Now use `appsody deploy` to push the image and deploy it.

```bash
appsody deploy -t <your image registry>/<your namespace>/quote-backend --push --namespace insurance-quote
```

where:

* `<your image registry>` is the host name of your regional registry, for example `docker.io`
* `<your namespace>` is a namespace you created in your registry

For example, your deploy command might look something like this:

```bash
appsody deploy -t docker.io/henrynash/quote-backend --push --namespace insurance-quote
```

> **NOTE**: Running `appsody deploy` will install the [appsody operator](https://github.com/appsody/appsody-operator) on the *Default* namespace of the cluster.

```bash
.
.
[Info] Deployed project running at quote-backend-i2.henrycluster3-5290c8c8e5797924dc1ad5d1b85b37c0-0001.eu-de.containers.appdomain.cloud
```

After the deployment completes, you can test the service using curl. The deployment should complete with something like:

```bash
$ curl -X POST -d @backend-input.json -H "Content-Type: application/json" http://<url-to-backend>/quote

{"quotedAmount":70,"basis":"Dacadoo Health Score API"}
```

where:

* `<url-to-backend>` is the endpoint given above at the end of running appsody deploy (i.e. *quote-backend-i2.henrycluster3-5290c8c8e5797924dc1ad5d1b85b37c0-0001.eu-de.containers.appdomain.cloud* in the example above)

> **NOTE**: If you are not using the Dacadoo Health Score API, you may see different text for the value of "basis" -- ("mocked backend computation" instead of "Dacadoo Health Score API").

### 3. Deploy the frontend application to OpenShift

We are now going to deploy the frontend application to OpenShift. The steps are similar to what we did for the backend application.

First we need to generate the deployment yaml so that we can edit it. Change the current directory back to the frontend application and generate the deployment yaml.

```bash
cd ../quote-frontend
appsody deploy --generate-only
```

Edit the file that was created, `app-deploy.yaml`, and add the `env` section as shown below (which defines an environment variable with the URL of the backend application within the cluster). Be careful to match the indentation (`env:` is indented the same number of spaces as `applicationImage:`). `url-to-backend` is the same as the one we tested about against the backend.

```yaml
apiVersion: appsody.dev/v1beta1
kind: AppsodyApplication
metadata:
  name: quote-frontend
spec:
  # Add fields here
  version: 1.0.0
  applicationImage: quote-frontend
  env:
  - name: BACKEND_URL
    value: <url-to-backend>
  .
  .
  .
```

Save the yaml file and do the deployment.

```bash
appsody deploy -t <your image registry>/<your namespace>/quote-frontend --push  --namespace insurance-quote
```

where, as before:

* `<your image registry>` is the host name of your regional registry, for example `docker.io`
* `<your namespace>` is a namespace you created in your registry

After the deployment completes, you can test the service using curl. The deployment should complete with something like:

```bash
.
.
[Info] Deployed project running at quote-frontend-i2.henrycluster3-5290c8c8e5797924dc1ad5d1b85b37c0-0001.eu-de.containers.appdomain.cloud
```

You can then use a browser to open the frontend application, at the url given above. Fill in the form and click the button to submit it. You should get a quote from the backend application.

![Sample web form](images/screenshot.png)

> Note: If you are not using the Dacadoo Health Score API, you may see different text after the quote
("determined using mocked backend computation" instead of "determined using Dacadoo Health Score API").

Congratulations, you have now deployed both front and backend applications to OpenShift, hooked them together as well as enable outreach to an external service.
