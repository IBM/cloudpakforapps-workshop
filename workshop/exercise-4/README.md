# Exercise 4: Use Tekton and Kabanero Pipelines to continuously deploy

In this exercise we're going to take our insurance quote application from exercise 3 and instead of deploying it as a stand alone app, we will push the code up to a github repo and use Tekton pipelines to constantly deploy the app to our openshift cluster and speed up your deployment process.

Mention the insurance quote arch again?

* The front-end is constructed with Node.js (we used the `nodejs-express` collection)
* The back-end is done in Java (we used the `java-spring-boot2` collection)

This section is broken up into the following steps:

1. Prereq: Clean up the deployed app
1. Launch the Tekton dashboard
1. Review pre-installed pipelines and tasks on Cloud Pak for Apps
1. Get a GitHub Access Token
1. Upload insurance quote frontend, and backend to GitHub
1. Configure Tekton with Github Access Token
1. Configure Tekton to point to repos

## Prereq: Clean up the deployed app

First we delete the deployments, run the `appsody deploy delete` command to remove them.

```bash
cd ~/appsody-apps/quote-frontend
appsody deploy delete --namespace insurance-quote
cd ~/appsody-apps/quote-backend
appsody deploy delete --namespace insurance-quote
```

```bash
$ appsody deploy delete --namespace insurance-quote
Deleting deployment using deployment manifest app-deploy.yaml
Attempting to delete resource from Kubernetes...
Running command: kubectl delete -f app-deploy.yaml --namespace insurance-quote
Deployment deleted
```

Note, we still have the `insurance-quote` namespace, the `dacadoo-config` config map, the `appsody-operator` deployment, and the images in our registry.

## Go to the Tekton dashboard

You can the tekton dashboard from Cloud Pak for Apps.

![Launch Tekton](images/launch_tekton.png)

You can also obtain the URL for the tekton dashboard by using `oc get routes`. We want to use the address that looks like `tekton-dashboard-kabanero.xyz.domain.containers.appdomain.cloud`.

```bash
$ oc get routes --namespace kabanero
NAME               HOST/PORT                                                                                                             PATH      SERVICES           PORT      TERMINATION          WILDCARD
icpa-landing       ibm-cp-applications.cpa-workshop-dev-5290c8c8e5797924dc1ad5d1b85b37c0-0001.us-east.containers.appdomain.cloud                   icpa-landing       <all>     reencrypt/Redirect   None
kabanero-cli       kabanero-cli-kabanero.cpa-workshop-dev-5290c8c8e5797924dc1ad5d1b85b37c0-0001.us-east.containers.appdomain.cloud                 kabanero-cli       <all>     passthrough          None
kabanero-landing   kabanero-landing-kabanero.cpa-workshop-dev-5290c8c8e5797924dc1ad5d1b85b37c0-0001.us-east.containers.appdomain.cloud             kabanero-landing   <all>     passthrough          None
tekton-dashboard   tekton-dashboard-kabanero.cpa-workshop-dev-5290c8c8e5797924dc1ad5d1b85b37c0-0001.us-east.containers.appdomain.cloud             tekton-dashboard   <all>     reencrypt/Redirect   None
```

## 1. Review pre-installed pipelines and tasks on Cloud Pak for Apps

There are 5 **Pipelines**, one for each collection kabanero comes with (java microprofile, spring, nodejs, express, and loopback). **Pipelines** are a first class structure in Tekton. **Pipelines** are a series of **Tasks**.

Run this command to see the available pipelines.

```bash
oc get pipeline -n kabanero
```

You will see something similar to this.

```bash
$ oc get pipeline -n kabanero
NAME                                           AGE
java-microprofile-build-deploy-pipeline        15d
java-spring-boot2-build-deploy-pipeline        15d
nodejs-build-deploy-pipeline                   15d
nodejs-express-build-deploy-pipeline           15d
nodejs-loopback-build-deploy-pipeline          15d
pipeline0                                      15d
```

These are visible through the UI, too:

![Pre-Existing Pipelines](images/tekton_pipelines.png)

There are 10 **Tasks**, two for each collection kabanero comes with. Each collection has 2 **Tasks**, a *Build Task* and a *Deploy Task*.

```bash
oc get pipeline -n kabanero
```

You will see something similar to this.

```bash
stevemar@quote-frontend $ oc get tasks -n kabanero
NAME                            AGE
java-microprofile-build-task    27d
java-microprofile-deploy-task   27d
java-spring-boot2-build-task    27d
java-spring-boot2-deploy-task   27d
monitor-result-task             27d
nodejs-build-task               27d
nodejs-deploy-task              27d
nodejs-express-build-task       27d
nodejs-express-deploy-task      27d
nodejs-loopback-build-task      27d
nodejs-loopback-deploy-task     27d
pipeline0-task                  27d
```

These are visible through the UI, too:

![Pre-Existing Tasks](images/tekton_tasks.png)

### Get a GitHub Access Token

When using Tekton, building a pipeline will require code to be pulled from either a public or private repository. When configuring Tekton, for security reasons, we will create an *Access Token* instead of using a password.

To create an *Access Token*, from <github.com> click on your profile icon in the top left. Then go to `Settings` -> `Developer Settings` -> `Personal Access Tokens`. Or go directly to <https://github.com/settings/tokens>

![Choose to create a new Access Token](images/github_access_tokens.png)

Here we want to generate a token, so `Click` on the `Generate a Token`. The token permissions need to be the `repo` which gives read and write access to the repository.

![Generate a new Access Token](images/github_create_token.png)

Once the token is created, make sure to copy it down. We will need it later.

## Upload insurance quote frontend, and backend to GitHub

Open <Github.com> and `login` with your username and password.

Go to <https://github.com/new> and create two new repositories, `quote-frontend`, and `quote-backend`. Do not initiatize the repos with a license file or README.

![New repo](images/new_repo.png)

From your `quote-backend` directory, run the commands below, replacing `<username>` with your own.

```bash
git init
git add -A
git commit -m "first commit"
git remote add origin git@github.com:<username>/quote-backend.git
git push -u origin master
```

The repo for your frontend code should look like this:

![Repo for frontend](images/repo_frontend.png)

The repo for your backend code should look like this:

![Repo for backend](images/repo_backend.png)

## Re-add config map because namespace limitation

Do this again because I can't seem to deploy to any namespace aside from `kabanero`

```bash
$ oc create configmap dacadoo-config --from-literal=DACADOO_URL=https://models.dacadoo.com/score/2 --from-literal=DACADOO_APIKEY=Y3VB...RMGG
configmap/dacadoo-config created
```

## Add webhooks to Tekton to watch Github repo changes

Configure the github webhook to your repo. Go to `Webhooks` > `Add Webhook` and then create the webhook.

![new webhook options](images/create-tekton-webhook.png)

Note that the first time creating a webhook a new access token must also be created, use the access token from the earlier step:

![Create an access toekn](images/create-token.png)

### Create a webhook for the backend

```ini
Name: backend-webhook
Repository URL: http://github.com/{username}/quote-backend
Access Token: github-tekton

Namespace: kabanero
Pipeline: java-spring-boot2-build-deploy-pipeline
Service account: kabanero-operator
Docker Registry: docker-registry.default.svc:5000/kabanero
```

### Create a webhook for the frontend

```ini
Name: frontend-webhook
Repository URL: http://github.com/{username}/quote-frontend
Access Token: github-tekton

Namespace: kabanero
Pipeline: nodejs-express-build-deploy-pipeline
Service account: kabanero-operator
Docker Registry: docker-registry.default.svc:5000/kabanero
```

Verify both are created successfully.

![the webhooks exist](images/both-tekton-webhooks.png)

### Check Github repo settings

Go to the repo and check the settings tab to see the webhooks, Click the webhook

![Webhook overview](images/github-webhook-overview.png)

Scroll down to see any payloads being delivered. There is currently a bug where the first payload is not delivered. Not to worry, we'll be making changes to the code anyway, that will trigger a new payload.

![Webhook payload](images/webhook-payload.png)

## Test it all out

In your `quote-backend` repo, change the file `quote-backend/src/main/java/application/Quote.java`. Change a value in a logger statement.

This will trigger the tekton pipleine. Go to the tekton dashboard and access the new pipeline it created.

![See the java deploy pipeline](images/view-tasks.png)

Wait until the task is complete, then find the route using `oc get routes`:

```bash
$ oc get routes -n kabanero | grep backend
quote-backend      quote-backend-kabanero.cp4apps-workshop-prop-5290c8c8e5797924dc1ad5d1b85b37c0-0001.us-east.containers.appdomain.cloud                quote-backend      8080                           None
```

In your `quote-frontend` repo, change the file `app-deploy.yml` to update the `BACKEND_URL` value with the URL from the previous step.

```yaml
  env:
  - name: BACKEND_URL
    value: http://quote-backend-kabanero.cp4apps-workshop-prop-5290c8c8e5797924dc1ad5d1b85b37c0-0001.us-east.containers.appdomain.cloud/quote
```

This should trigger another pipeline to be created, using the node-express pipeline.

![Two PipelineRuns should appear](images/view-pipelines.png)

Wait until the task is complete, then find the route using `oc get routes`:

```bash
$ oc get routes -n kabanero | grep frontend
quote-frontend     quote-frontend-kabanero.cp4apps-workshop-prop-5290c8c8e5797924dc1ad5d1b85b37c0-0001.us-east.containers.appdomain.cloud               quote-frontend     3000                           None
```

The usual frontend should show.

Congratulations, Day 1 of the workshop is now complete!
