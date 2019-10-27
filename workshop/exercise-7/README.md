# Exercise 7: Configuring Kabanero to use an Alternate Collection Repository

> ***WORK IN PROGRESS***

This section is broken up into the following steps:

1. [TBA](#1-TBA)

## 1. TBA

A Kabanero custom resource (CR) instance can be configured to use an alternate collection repository.  Follow these steps to use that collection repository with Kabanero:

Create organizational-level teams in Github that should administer the cloned collection(s), and add members to those teams.  These members will be able to use the link:kabanero-cli.html[Kabanero CLI] to administer the collections in the namespace where the Kabanero CR instance is configured.

Obtain the URL to the collection repository.  If a Git release was created for the collections, the URL format will be: `https://<github.com>/<organization>/collections/releases/download/<release>/kabanero-index.html`

* Replace `<github.com>` with your Github or GHE hostname
* Replace `<organization>` with your Github organization name
* Replace `<release>` with the name of the release that was created

Find the name of your Kabanero CR instance.  Use `oc get kabaneros -n kabanero` to obtain a list of all Kabanero CR instances in namespace `kabanero`.  The default name for the CR instance is `kabanero`.  Then, edit the speific CR instance using `oc edit kabanero <name> -n kabanero`, replacing `<name>` with the instance name.

Modify your Kabanero custom resource (CR) instance to target the new collections that were pushed to the remote Github repository, and the teams in Github that should administer the collection(s).  Specifically:

* The `Spec.Collections.Repositories.url` attribute should be set to the URL of the collection repository.
* The `Spec.Github.organization` attribute should be set to the organization hosting the collections in the remote Github repository.  In the example above, the organization name is `my_org`.
* The `Spec.Github.teams` attribute should be set to a comma separated list of Github teams in the remote Github repository, whose members can administer the collection using the Kabanero CLI.
* The `Spec.Github.apiurl` attribute should be set to the API URL for the remote Github repository being used.  For example, the API URL for `github.com` is `api.github.com`.

A modified Kabanero CR instance for a collection repository located in the `my_org` organization of the `github.example.com` Github repository using release `v0.1` of collections might look like this:

```yaml
apiVersion: kabanero.io/v1alpha1
kind: Kabanero
metadata:
  name: kabanero
  namespace: kabanero
spec:
  collections:
    repositories:
    - name: custom
      url: https://github.example.com/my_org/collections/releases/download/v0.1/kabanero-index.yaml
      activateDefaultCollections: true
  github:
    organization: my_org
    teams:
      - collection-admins
      - admins
    apiurl: api.github.com
```

For more information about other fields that can be customized in the Kabanero CR instance, see link:kabanero-cr-config.html[the Kabanero CR configuration reference].

When you are done editing, save your changes and exit the editor.  The updated Kabanero CR instance will be applied to your cluster.

The Kabanero operator will now load the collections in the repository.  To see a list of all collections in the `kabanero` namespace, use `oc get collections -n kabanero`.  If the kabanero-operator is unable to apply the collections, the `Status` section of the Kabanero CR instance or the Collection CR instances will contain more information.
