# Workshop: Creating Cloud Native Applications with Cloud Pak for Applications on OpenShift

## Agenda

We'll be using the Cloud Pak for Applications platform to perform the following tasks:

### Day 1: Kabanero and Appsody for Developers and Operators

In this frist day we'll learn how to use Appsody to run the *inner loop* of the development and test cycle for a developer, and how these tools can be integrated into your favorite IDE. We'll also explore how to deploy an application to OpenShift first manually with Appsody and then using the standard Kabanero Tekton piplines with GitOps.

|   |   |
| - | - |
| [Lecture 1: What is Cloud Native?](https://ibm.box.com/s/3pvl4jdi3xifs1olzcl9np904zvk5ueo) | Learn about the technologies that underpin Cloud Native applications |
| [Lecture 2: Kabanero Overview](https://ibm.box.com/s/6jl4b7sj8xqgh7rvxtea5ykpsjyu1siz) | Learn about Kabanero. An open source project to rapidly create Cloud Native applications |
| [Exercise 1: Introduction to Appsody and Codewind](exercise-1/README.md) | Install Appsody into the IDE with Codewind, Learn about the developer flow, building your first application with Appsody |
| [Exercise 2: Using Appsody CLI to develop, test, and debug applications](exercise-2/README.md) | Use the Appsody CLI to quickly create frontend and backend applications for a sample application using two different technologies (Spring and nodejs express) |
| [Exercise 3: Deploying to OpenShift with Appsody](exercise-3/README.md) | Deploy the built applications to IBM Managed OpenShift |
| [Lecture 3: Adding value with IBM Cloud Pak for Applications](https://ibm.box.com/s/y4wh104vdos1vw5kdjwwuhebf8jgq580) | Learn about how IBM Cloud Pak for Applications bundles everything together |
| [Exercise 4: Use Tekton and Kabanero Pipelines to continuously deploy](exercise-4/README.md) | Deploy the built applications to IBM Managed OpenShift using GitOps to trigger a Tekton pipeline |


### Day 2: Customizing Stacks, Pipelines in Kabanero Collections

* **Building a custom Kabanero Collection**
  * Create a collection that will contain custom appsody stacks and pipelines

#### Customizing Stacks for Solution Architects (Track 1)

* **Customizing an existing Appsody Stack**
  * Create a custom stack, to be hosted in our custom repository
* **Managing custom stacks in a custom Kabanero Collection**
  * Learn how to manage these custom stacks and how to make them available to developers.

#### Customizing Kabanero Collections for Operators (Track 2)

* **Create a custom Tekton pipleline for a custom Collection**
  * Build a pipeline that will fit into a custom Kabanero collection

#### Using your custom collections in Kabanero (Final Common Track)

* **Deploy Application with Custom Stack & Pipeline**
  * Build and deploy an application using the custom stack, collection and pipelines built by the Architects' and Operators' tracks

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
