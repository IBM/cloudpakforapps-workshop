
## Creating Cloud Native Applications with Cloud Pak for Applications on OpenShift

Welcome to our workshop! In this workshop we'll be using the Cloud Pak for Applications platform to create Cloud Native Applications that run on OpenShift. The goals of this workshop are:

* Use Appsody and Codewind to create a cloud native application
* Create a custom Collection
* Use Tekton CI to continuously deploy to OpenShift

![Tools used in the workshop](.gitbook/images/tools-for-workshop.png)

### About this workshop

The introductory page of the workshop is broken down into the following sections:

* [Agenda](#agenda)
* [Compatability](#compatability)
* [About Cloud Pak for Applications](#about-cloud-pak-for-applications)
* [Credits](#credits)

## Agenda

### Day 1: Kabanero and Appsody for Developers and Operators

In this first day we'll learn how to use Appsody to run the *inner loop* of the development and test cycle for a developer. We'll also explore how to deploy an application to OpenShift, first manually with Appsody for dev/test purposes, and then using the standard Kabanero Tekton piplines with GitOps as part of a continual test/production cycle.

| Section | Description |
| - | - |
| **[Lecture 1: Kabanero Overview](https://ibm.box.com/s/6jl4b7sj8xqgh7rvxtea5ykpsjyu1siz)** | Learn about Kabanero. An open source project to rapidly create Cloud Native applications |
| **[Exercise 2: Using Appsody CLI to develop, test, and debug applications](../exercise-2/README.md)** | Use the Appsody CLI to quickly create frontend and backend applications for a sample application using two different technologies (Spring and nodejs express) |
| **[Lecture 3: Adding value with IBM Cloud Pak for Applications](https://ibm.box.com/s/y4wh104vdos1vw5kdjwwuhebf8jgq580)** | Learn about how IBM Cloud Pak for Applications bundles everything together |
| **[Exercise 3: Deploying to OpenShift with Appsody](../exercise-3/README.md)** | Deploy the built applications to IBM Managed OpenShift with Appsody for dev/test purposes |
| **[Exercise 4: Use Tekton and Kabanero Pipelines to continuously deploy](exercise-4/README.md)** | Deploy the built applications to IBM Managed OpenShift using GitOps to trigger a Tekton pipeline |

### Day 2: Customizing Stacks, Pipelines in Collections

In the second day we'll learn about the Kabanero open source project and how to productionize our applications with custom Appsody Stacks, custom Collections, and custom Tekton pipelines.

| Section | Description |
| - | - |
| **[Lecture 4: Customizing Appsody and Kabanero](https://ibm.box.com/s/kbuympaqftxswyi1aoswdlqussmqf1ba)** | Learn about the stacks and repos |
| **[Exercise 5: Customizing an existing Appsody Stack](../exercise-5/README.md)** | Create a custom stack, to be hosted in our custom repository |
| **[Exercise 6: Building a custom Collection](../exercise-6/README.md)** | Create a collection that will contain custom appsody stacks and pipelines |
| **[Lecture 5: Tekton Overview](https://ibm.box.com/s/tg0f6nhs91trlzkb5pfnh5e1rdzg4wm6)** | Learn about Tekton CI/CD and how Kabanero uses it |
| **[Exercise 9: Deploy an application with a custom Stack, custom Collection, and custom Pipeline](../exercise-9/README.md)** | Build and deploy an application using the custom stack, collection and pipelines built by the Architects' and Operators' tracks |

## Compatability

This workshop has been tested on the following platforms:

* **macOS**: Mojave (10.14), Catalina (10.15)
* **Windows** Windows 10 (with enterprise AAD and git bash)

## About Cloud Pak for Applications

IBM Cloud Pak for Applications is an enterprise-ready, containerized software solution for modernizing existing applications and developing new cloud-native apps that run on Red Hat® OpenShift®. Built on IBM WebSphere offerings and Red Hat OpenShift Container Platform with the Kabanero open source project, Cloud Pak for Applications provides a long-term solution to help you transition between public, private, and hybrid clouds, and create new business applications.

### A few other noteworthy mentions

Cloud Pak for Applications:

* ... includes
  * the Kabanero open source project
  * WebSphere
  * Mobile Foundation
  * IBM Cloud Private
  * Transformation Advisory
  * ...and more
* ... can be deployed on any major cloud provider supporting OpenShift (IBM Cloud, AWS, Azure, GCP)

![Cloud Pak for Application Stack](.gitbook/images/cp4apps.png)

## Credits

This workshop was primarily written by [Henry Nash](https://github.com/henrynash) and [Steve Martinelli](https://github.com/stevemar). Many other IBMers have contributed to help shape, test, and contribute to the workshop.

* [Greg Dritschler](https://github.com/GregDritschler): For his [Insurance Quote Code Pattern](https://github.com/IBM/appsody-sample-quote-app)
* [Carlos Santana](https://github.com/csantanapr): For his [Learning Kabanero 101 Tutorial](https://ibm-cloud-architecture.github.io/Learning-Kabanero-101)
* [Tim Robinson](https://github.com/timroster): For testing the lab on Windows
