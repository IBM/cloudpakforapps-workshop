# Exercise 6: Building a custom Appsody Stack repository

> ***WORK IN PROGRESS***

This section is broken up into the following steps:

1. Review concepts
1. Create a new repo
1. Set up a local build environment
1. Build collections
1. Test the collections locally using Appsody
1. Push changes back to your repository
1. Release the final version of the collections

## 1. Review

Collections are categorized as either `stable`, `incubator` or `experimental` depending on the content of the collection.

* `stable/`: Stable collection meet a set of technical requirements.
* `incubator/`: The collection in the incubator folder are actively being worked on to satisfy the stable criteria.
* `experimental/`: Experimental collections are not being actively been worked on and may not fulfill the requirements of a stable collection. These can be used for trying out specific capabilities or proof of concept work.

### Kabanero Collections

Kabanero provides pre-configured collections that enable rapid development and deployment of quality microservice-based applications. Collections include an Appsody stack (base container image and project templates) and pipelines which act as a starting point for your application development.

### Appsody Stacks

Stacks include language runtimes, frameworks and any additional libraries and tools that are required to simplify your local application development. Stacks are an easy way to manage consistency and adopt best practices across many applications.
Click here to find out more about [Appsody stacks](https://github.com/appsody/website/blob/master/content/docs/stacks/stacks-overview.md).

> **NOTE: Kabanero only builds and publishes collections that are categorized as 'incubator' or 'stable'**

## Create a new repo

The default collections can be modified to suit the needs of your organization.  Use the following steps to customize the default collections and store them in a new Github repository:

1. Clone the default collections repository and create a new copy of it in your Github organization.  In this example, we are referring to `github.example.com` as the remote Github repository, and we refer to it locally as `private-org`.

```bash
git clone https://github.com/kabanero-io/collections.git
cd collections
git remote add private-org https://github.example.com/my_org/collections.git
git push -u private-org
```

Once this has been done, you will have your own copy of the collections repository in your own Github org/repo. Follow any normal development processes you have for using git (i.e., creating branches, etc.).

## Set up a local build environment

There are several tools that are used to build:

* yq: Command-line YAML processor  (sudo snap install yq)
* docker: A tool to help you build and run apps within containers

These are only required if you are also building the Codewind Index (export CODEWIND_INDEX=true):::

* python3: Python is a general-purpose interpreted, interactive, object-oriented, and high-level programming language
* pyyaml: YAML parser and emitter for python (pip3 install pyyaml)

There are several environment variables that need to be set up. These are required in order to correctly build the collections.

```bash
# Organization for images
export IMAGE_REGISTRY_ORG=kabanero

# Whether to build the Codewind Index file
export CODEWIND_INDEX=false
```

These settings are also required to correctly release the collections (if done manually):

```bash
# Publish images to image registry
export IMAGE_REGISTRY_PUBLISH=false

# Credentials for publishing images:
export IMAGE_REGISTRY=<registry>
export IMAGE_REGISTRY_USERNAME=<registry_username>
export IMAGE_REGISTRY_PASSWORD=<registry_password>
```

## Build collections

From the base directory, run the build script.  For example:

```bash
. ./ci/build.sh
```

Note that this will build all the collections in the incubator directory.

Following the build, you can find the generated collection assets in the `file://$PWD/ci/assets/` directory and all the docker images in your local docker registry.

## Test the collections locally using Appsody

To test the collections, add the `kabanero-index.yaml` to Appsody using the Appsody CLI:

```bash
appsody repo add kabanero file://$PWD/ci/assets/kabanero-index-local.yaml
```

This will enable you to do an `appsody init` for a collection that is in the newly built kabanero collections.  For example:

```bash
appsody init kabanero/java-microprofile
```

## Push changes back to your repository

Once you have made all the changes to the collection and you are ready to push the changes back to your git repository then

```bash
# Commit your changes back to git
git commit -a -m "Updates to the collections"

# Push the changes to your repository.   For example:
git push -u private-org
```

If Travis CI has been setup in your git organization, the push to git should trigger the Travis build to run, which will ensure that the changes build OK.

## Release the final version of the collections

Once all changes have been made to the Collections and they are ready to be released, if a full release of the collections is required, create a git tag:

```bash
git tag "v0.1.1 -m "Collections v0.1.1"
# push the tags to git:
git push --tags
```

This will trigger another Travis build that will also generate a Git Release and push the images to the image repository.

Test the pipelines and other components that have been included in the collection link:collection-install.html[within the Kabanero/OpenShift environment].

Declare the release final.  If you need to make additional changes, repeat the process using the same repository you created in the first step, and create a new tag to represent a new release.

## References

### Kabanero Repo structure

This is a simplified view of the Kabanero Collections github repository structure.

```ini
ci
├── [ files used for CI/CD of the Kabanero collections ]
incubator
├── common/
|   ├── pipelines/
|   |   ├── common-pipeline-1/
|   |   |       └── [pipeline files that make up a full tekton pipeline used with all collections in incubator category]
|   |   └── common-pipeline-n/
|   |           └── [pipeline files that make up a full tekton pipeline used with all collections in incubator category]
├── collection-1/
|   ├── [collection files - see collection structure below]
├── collection-2/
|   └── [collection files - see collection structure below]
stable
├── common/
|   ├── pipelines/
|   |   ├── common-pipeline-1/
|   |   |       └── [pipeline files that make up a full tekton pipeline used with all collections in stable category]
|   |   └── common-pipeline-n/
|   |           └── [pipeline files that make up a full tekton pipeline used with all collections in stable category]
├── collection-1/
|   ├── [collection files - see collection structure below]
├── collection-n/
|   └── [collection files - see collection structure below]
experimental
├── common/
|   ├── pipelines/
|   |   ├── common-pipeline-1/
|   |   |       └── [pipeline files that make up a full tekton pipeline used with all collections in experimental category]
|   |   └── common-pipeline-n/
|   |           └── [pipeline files that make up a full tekton pipeline used with all collections in experimental category]
├── collection-1/
|   ├── [collection files - see collection structure below]
└── collection-n/
    └── [collection files - see collection structure below]
```

### Kabanero Collection structure

There is a standard structure that all collections follow. The structure below represents the source structure of a collection:

```ini
my-collection
├── README.md
├── stack.yaml
├── collection.yaml
├── image/
|   ├── config/
|   |   └── app-deploy.yaml
|   ├── project/
|   |   ├── [files that provide the technology components of the stack]
|   |   └── Dockerfile
│   ├── Dockerfile-stack
|   └── LICENSE
├── pipelines/
|   ├── my-pipeline-1/
|   |       └── [pipeline files that make up the full tekton pipeline]
└── templates/
    ├── my-template-1/
    |       └── [example files as a starter for the application, e.g. "hello world"]
    └── my-template-2/
            └── [example files as a starter for a more complex application]

```

The structure above is then processed when you build the collection, to generate a Docker image for the stack, along with tar files of each of the templates and pipelines, which can then all be stored/referenced in a local or public appsody repo. Refer to the section on [Building and Testing Stacks](https://github.com/appsody/website/blob/master/content/docs/stacks/build-and-test.md) for more details. The appsody CLI can then access such a repo, to use the stack to initiate local development.

### stack.yaml

The `stack.yaml` file in the top level directory defines the different attributes of the stack and which template the stack should use by default. See the example below:

```yaml
name: Sample Application Stack   # concise one line name for the stack
version: 0.1.0                   # version of the stack
description: sample stack to help creation of more appsody stacks # free form text explaining more about the capabilities of this stack and various templates
license: Apache-2.0              # license for the stack
language: nodejs                 # programming language the stack uses
maintainers:                     # list of maintainer(s) details
  - name: John Smith
    email: example@example.com
    github-id: jsmith
default-template: my-template-1  # name of default template
```

real one:

```yaml
---
stacks:
  - default-template: default
    description: "Eclipse MicroProfile on Open Liberty & OpenJ9 using Maven"
    id: java-microprofile
    language: java
    license: Apache-2.0
    maintainers:
      - email: emily@exmple.com
        github-id: emily
        name: "emily"
    name: "Eclipse MicroProfile®"
    templates:
      - id: default
        url: "https://github.com/appsody/stacks/releases/download/java-microprofile-v0.2.18/incubator.java-microprofile.v0.2.18.templates.default.tar.gz"
    version: "0.2.18"
```

### Collection.yaml

The `collection.yaml` file in the top level directory defines the different attributes of the collection and which container image and pipeline the collection should use by default. See the example below:

```yaml
default-image: java-microprofile # name of the default container image - reference into the images element below
default-pipeline: default        # name of the default pipeline - reference to the pipeline in the directory structure
images:                          # list of container images
- id: java-microprofile
  image: $IMAGE_REGISTRY_ORG/java-microprofile:0.2
```

Real example:

```yaml
stacks:
  - default-image: java-microprofile
    default-pipeline: default
    images:
      - id: java-microprofile
        image: "kabanero/java-microprofile:0.2"
    pipelines:
      - id: default
        sha256: a59a779825c543e829d7a51e383f26c2089b4399cf39a89c10b563597d286991
        url: "https://github.com/kabanero-io/collections/releases/download/v0.1.2/incubator.common.pipeline.default.tar.gz"
```

### README

The top level directory must contain a `README.md` markdown file that describes the contents of the collection and how it should be used.

### LICENSE

The `image` directory must contain a `LICENSE` file.

### app-deploy.yaml

The `app-deploy.yaml` is the configuration file for deploying an Appsody project using the Appsody Operator. For more information about specifics, see [Appsody Operator User Guide](https://github.com/appsody/appsody-operator/blob/master/doc/user-guide.md).

### Dockerfile-stack

The `Dockerfile-stack` file in the `image` directory defines the foundation stack image, and a set of environment variables that specify the desired behaviour during the rapid local development cycle. It also defines what is exposed from the host machine to the container during this mode.

Environment variables can be set to alter the behaviour of the CLI and controller (see [Appsody Environment Variables](https://github.com/appsody/website/blob/master/content/docs/stacks/environment-variables.md)).

### Dockerfile

The `Dockerfile` in the `image/project` directory defines the final image that will created by the `appsody build` command, which needs to contain the content from both the stack itself along with the user application (typically modified from one of the templates). This is used to run the application as a whole, outside of appsody CLI control.

### Templates

A template is a pre-configured starter application that is ready to use with the particular stack image. It has access to all the dependencies supplied by that image and is able to include new functionality and extra dependencies to enhance the image. A stack can have multiple templates, perhaps representing different classes of starter applications using the stack technology components.

### Pipelines

A pipeline is set of Tekton pipelines (k8s-style resources for declaring CI/CD-style pipelines) to use with the particular collection. A collection can have multiple pipelines.

### .appsody-config.yaml

The `.appsody-config.yaml` is not part of the source structure, but will be generated as part of the stack building process, and will be placed in the user directory by the `appsody init`, command. This file specifies the stack image that will be used, and can be overridden for testing purposes to a locally built stack.

For example, the following specifies that the template will use the python-flask image:

```yaml
stack: python-flask:0.1
```
