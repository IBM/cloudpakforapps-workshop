# Workshop: Creating Cloud Native Applications with Cloud Pak for Applications on OpenShift

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

* **Customizing an existing Appsody Stack**
  * Create a custom stack, to be hosted in our custom repository
* **Building a custom Appsody Stack repository**
  * Create a repository that will contain custom appsody stacks
  * Learn how to manage these custom stacks and how to make them available to developers.

### Kabanero for Operators  (Track 2)

* **Building a simple Tekton pipeline**
  * ?
* **Create a Tekton pipleline for a custom collection**
  * Build a pipeline that will fit into a custom Kabanero collection

### Kabanero for All  (Common Track)

* **Deploy Application from Custom Stack & Repository**
  * Build and deploy an application using the custom stack, repository and pipelines built by the Architects' and Operators' tracks

## About Cloud Pak for Applications

IBM® Cloud Pak for Applications is an enterprise-ready, containerized software solution for modernizing existing applications and developing new cloud-native apps that run on Red Hat® OpenShift®. Built on IBM WebSphere® offerings and Red Hat OpenShift Container Platform with IBM Kabanero Enterprise, Cloud Pak for Applications provides a long-term solution to help you transition between public, private, and hybrid clouds, and create new business applications.

### A few other noteworthy mentions

Cloud Pak for Applications:

* ... includes
  * Kabanero Enterprise
  * WebSphere
  * Mobile Foundation
  * IBM Cloud Private
  * Transformation Advisory
  * ...and more
* ... can be deployed on any major cloud provider supporting OpenShift (IBM Cloud, AWS, Azure, GCP)

## About this Workshop

This workshop was created by Henry Nash and Steve Martinelli. Content was leveraged content from other IBM'ers such as:

* [Appsody Code Pattern - Greg Dritschler](https://github.com/IBM/appsody-sample-quote-app)
* [Learning Kabanero 101 - Cloud Garage / Carlos Santana](https://ibm-cloud-architecture.github.io/Learning-Kabanero-101)

This workshop has been tested on the following platforms:

* MacOS
