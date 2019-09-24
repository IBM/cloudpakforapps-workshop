# Cloud Native Applications Workshop

## Agenda

We'll be using the Cloud Pak for Applications platform to perform the following tasks:

### Kabanero for Developers (Common Track)

* **Pre-work**
  * Configuring your envionment with Docker, git, (a local kubernetes cluster ?) and access to IBM Managed OpenShift
* **Appsody with Codewind**
  * Install Appsody into the IDE with Codewind
  * Learn about the developer flow, building your first application with Appsody
* **Using Appsody CLI to develop/test/debug applications**
  * Use the Appsody CLI to quickly create frontend and backend applications for a sample application using two different technologies (Spring and nodejs express)
  * Run locally in Rapid Local Devlopement Mode
  * Deploy to your local kubernetes (?)
* **Deploying to OpenShift with Appsody**
  * Deploy the built applications to IBM Managed OpenShift

### Kabanero for Solution Architects (Track 1)

* **Building a custom Appsody Stack repository**
  * Create a repository that will contain custom appsody stacks
  * Learn how to manage these custom stacks and how to make them available to developers.
* **Customizing an existing Appsody Stack**
  * Create a custom stack, to be hosted in our custom repository
* **Building your own Appsody Stack**
  * (Do we want to do this as part of this workshop?)
  
### Kabanero for Operators  (Track 2)

* **Building a simple Tekton pipeline**
  * ?
* **Create a Tekton pipleline for a custom collection**
  * Build a pipeline that will fit into a custom Kabanero collection
  
### Kabanero for All  (Common Track)

* **Deploy Application from Custom Stack & Repository**
  * Build and deploy an application using the custom stack, repository and pipelines built by the Architects' and Operators' tracks
  
## About Cloud Pak for Applications

(Rewrite the below to Applications)...

Cloud Pak for Data represents an all-in-one platform for all your data needs. Cloud Pak for data tries to eliminate silos between Architect, Data Scientist, Developer, and Data Stewards. Cloud Pak for Data helps to streamline work by creating a pipeline for collecting, organizing, analyzing, and consuming data.

![Cloud Pak for Data pipeline](.gitbook/assets/images/generic/cp4data.png)

### A few other noteworthy mentions

Cloud Pak for Data:

* ... can be installed on Red Hat OpenShift or stand-alone
* ... can be extended to include over 20 [add-ons](https://docs-icpdata.mybluemix.net/extend/com.ibm.icpdata.doc/zen/admin/add-ons.html)
  * Watson Assistant
  * Watson OpenScale
  * R Studio
  * Data Virtualization
  * any many more
* ... can be deployed on any major cloud provider (AWS, Azure, GCP)
* ... provides a free 7-day trial -- [Cloud Pak Experience](https://www.ibm.com/cloud/garage/cloud-pak-experiences/)

![Cloud Pak for Data stack](.gitbook/assets/images/generic/cpd-stack.png)

### Our Cloud Pak for Data environment

For this workshop we'll be using Cloud Pak for Data with the following add-ons:

* Watson Machine Learning
* Watson OpenScale
* Data Virtualization
* Data Refinery

The environment was deployed on an 8-node cluster with 3 master nodes (32 VCPU, 32 GB RAM), and 5 worker nodes (32 VCPU, 128 GB RAM).
