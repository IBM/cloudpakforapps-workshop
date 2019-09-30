# Exercise 3: Deploying to OpenShift with Appsody

(Rewrite this to use OpenShift not IKS)

n this exercise, we will show how to deploy the sample insurance quote application built in Exercise 2 to OpenShift using Appsody. Appsody is an open source project that provides the following tools you can use to build cloud-native applications:

When you have completed this exercise, you will understand how to

* use appsody to build and package an application with the stack contents ready for deployment
* deploy the applications to the IBM Cloud Kubernetes Service

## Prerequisites

In order to deploy the applications to the IBM Cloud Kubernetes Service, complete the following steps.

* [Install the CLIs to manage a cluster](https://cloud.ibm.com/docs/containers?topic=containers-cs_cli_install#cs_cli_install_steps)

* [Create a free Kubernetes cluster in IBM Kubernetes Service](https://cloud.ibm.com/docs/containers?topic=containers-getting-started#classic-cluster-create)

* [Create a private container registry in IBM Cloud Container Registry](https://cloud.ibm.com/docs/services/Registry?topic=registry-registry_setup_cli_namespace#registry_setup_cli_namespace)

* In order for the backend application to access the Dacadoo Health Score API, visit https://models.dacadoo.com/doc/ to request an API key for evaluation purposes. Access to this API is granted individually to insurance professionals. There is a mock implementation of the API in the code that you can use if you do not want to register.

# Steps

1. [Deploy the backend application to the IBM Cloud](#4-deploy-the-backend-application-to-the-IBM-Cloud)
1. [Deploy the frontend application to the IBM Cloud](#5-deploy-the-frontend-application-to-the-IBM-Cloud)

### 1. Deploy the backend application to the IBM Cloud

We are now going to deploy both applications to the IBM Cloud Kubernetes Service starting with the backend application.

We will use the `appsody deploy` command for the deployments.  This command:

* builds a deployment image for production usage (i.e. it does not include development-mode tools)
* pushes the image to your designated image registry
* builds a deployment yaml file
* applies the yaml file to your Kubernetes cluster

In order to have the backend application sends requests to the Dacadoo Health Score API,
we need to create a secret that contains the configuration for making requests to the Dacadoo server.
(Note: If you do not want to use the Dacadoo Health Score API, you can skip this setup and continue to use the mock endpoint.)

```bash
kubectl create secret generic dacadoo-secret --from-literal=url=<url> --from-literal=apikey=<apikey>
```

where

* `<url>` is the URL of the Dacadoo server (e.g. `https://models.dacadoo.com/score/2`)
* `<apikey>` is the API key that you obtained when you registered to use the API.

We need to modify the deployment yaml to pass the secret's values to the application.
The initial deployment yaml can be generated as follows.

```bash
appsody deploy --generate-only
```

This creates a file named `app-deploy.yaml` in your project.  Edit the file.
You will notice that this yaml file contains an `AppsodyApplication` custom resource.
This resource is handled by an Appsody operator that is installed into your cluster the first time you deploy an Appsody application.
The operator handles creating the standard Kubernetes resources (such as Deployment) from the `AppsodyApplication` resource.
It is beyond the scope of this code pattern to go into the details of this resource or the operator.
If you would like to know more about it, take a look at the [user guide](https://github.com/appsody/appsody-operator/blob/master/doc/user-guide.md).

Add the following bold lines to the yaml file.  These lines instruct Kubernetes how to set environment variables from the secret we just created.
Be careful to match the indentation (`env:` is indented the same number of spaces as `applicationImage:`).

```yaml
apiVersion: appsody.dev/v1beta1
kind: AppsodyApplication
metadata:
  name: quote-backend
spec:
  # Add fields here
  version: 1.0.0
  applicationImage: quote-backend
  <b>env:
    - name: DACADOO_URL
      valueFrom:
        secretKeyRef:
          name: dacadoo-secret
          key: url
    - name: DACADOO_APIKEY
      valueFrom:
        secretKeyRef:
          name: dacadoo-secret 
          key: apikey<b>
  .
  .
  .
```

You do not need to update `applicationImage` with your image registry because the `appsody deploy` command will take care of that.
However, because we're going to push the image to a private registry, we need to update the yaml with the pull secret which is needed to authenticate to the registry.
Your cluster is prepopulated with secrets to access each regional registry.

```bash
$ kubectl get secrets --field-selector type=kubernetes.io/dockerconfigjson
NAME                TYPE                             DATA   AGE
default-au-icr-io   kubernetes.io/dockerconfigjson   1      1d
default-de-icr-io   kubernetes.io/dockerconfigjson   1      1d
default-icr-io      kubernetes.io/dockerconfigjson   1      1d
default-jp-icr-io   kubernetes.io/dockerconfigjson   1      1d
default-uk-icr-io   kubernetes.io/dockerconfigjson   1      1d
default-us-icr-io   kubernetes.io/dockerconfigjson   1      1d
```

In order to determine which region you are using, you can use the `ibmcloud cr region` command.

```bash
$ ibmcloud cr region
You are targeting region 'us-south', the registry is 'us.icr.io'.
```

In this example the registry is `us.icr.io` so the corresponding secret to use is `default-us-icr-io`.
Add the following bold line to the yaml file (but use the correct secret for your region):

```yaml
apiVersion: appsody.dev/v1beta1
kind: AppsodyApplication
metadata:
  name: quote-backend
spec:
  # Add fields here
  version: 1.0.0
  applicationImage: quote-backend
  <b>pullSecret: default-us-icr-io</b>
  env:
    - name: DACADOO_URL
      valueFrom:
        secretKeyRef:
          name: dacadoo-secret
          key: url
    - name: DACADOO_APIKEY
      valueFrom:
        secretKeyRef:
          name: dacadoo-secret 
          key: apikey
  .
  .
  .
```

This completes the editing of the yaml file so save it.

At this point we're almost ready to push the image to the registry and deploy it to the cluster.
In order to push the image we need to login to the image registry first.

```bash
ibmcloud cr login
```

Now use `appsody deploy` to push the image and deploy it.

```bash
appsody deploy -t <your image registry>/<your namespace>/quote-backend:1 --push
```

where

* `<your image registry>` is the host name of your regional registry, for example `us.icr.io`
* `<your namespace>` is a namespace you created in your registry

After the deployment completes, you can test the service using curl.

```bash
$ curl -X POST  -d @backend-input.json  -H "Content-Type: application/json"  http://<node IP address>:<node port>/quote
{"quotedAmount":70,"basis":"Dacadoo Health Score API"}
```

where

* `<node IP address>` is the external IP address of your node which you can obtain using the command `kubectl get node -o wide`
* `<node port>` is the node port assigned to the service which you can obtain using the command `kubectl get svc quote-backend`

Note: If you are not using the Dacadoo Health Score API, you may see different text for the value of "basis"
("mocked backend computation" instead of "Dacadoo Health Score API").

Note that because we are using a free Kubernetes cluster, the AppsodyApplication is limited to exposing the service via a node port.
If you use a standard cluster with Knative installed, or a Red Hat OpenShift on IBM Cloud cluster, you have the option to expose the service via
an ingress resource or a route resource.

### 2. Deploy the frontend application to the IBM Cloud

We are now going to deploy the frontend application to the IBM Cloud Kubernetes Service.
The steps are similar to what we did for the backend application.

First we need to generate the deployment yaml so that we can edit it.
Change the current directory back to the frontend application and generate the deployment yaml.

```bash
cd ../quote-frontend
appsody deploy --generate-only
```

Edit the file that was created, `app-deploy.yaml`, and add the following bold lines to the yaml file.
The `pullSecret` should be the same value you used in the backend application.
The `env` section defines an environment variable with the URL of the backend application within the cluster.
Be careful to match the indentation (`pullSecret:` and `env:` are indented the same number of spaces as `applicationImage:`).

```yaml
apiVersion: appsody.dev/v1beta1
kind: AppsodyApplication
metadata:
  name: quote-frontend
spec:
  # Add fields here
  version: 1.0.0
  applicationImage: quote-frontend
  <b>pullSecret: default-us-icr-io
  env:
  - name: BACKEND_URL
    value: http://quote-backend:8080/quote</b>
  .
  .
  .
```

Save the yaml file and do the deployment.

```bash
appsody deploy -t <your image registry>/<your namespace>/quote-frontend:1 --push
```

where

* `<your image registry>` is the host name of your regional registry, for example `us.icr.io`
* `<your namespace>` is a namespace you created in your registry

After the deployment completes, use a browser to open the frontend application.
Use `http://<node IP address>:<nodeport>` where

* `<node IP address>` is the external IP address of your node which you can obtain using the command `kubectl get node -o wide`
* `<node port>` is the node port assigned to the service which you can obtain using the command `kubectl get svc quote-frontend`

Fill in the form and click the button to submit it.
You should get a quote from the backend application.

![quoteform2](doc/source/images/screenshot2.png)

Note: If you are not using the Dacadoo Health Score API, you may see different text after the quote
("determined using mocked backend computation" instead of "determined using Dacadoo Health Score API").
