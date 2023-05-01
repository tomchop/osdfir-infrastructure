<!--- app-name: Turbinia -->
# Turbinia Helm Chart

A Helm chart for Turbinia. Turbinia is an open-source framework for deploying, managing, and running distributed forensic workloads. It is intended to automate running of common forensic processing tools (i.e. Plaso, TSK, strings, etc) to help with processing evidence, scaling the processing of large amounts of evidence, and decreasing response time by parallelizing processing where possible.

[Overview of Turbinia](https://turbinia.readthedocs.io/en/latest/)

[Chart Source Code](https://github.com/google/osdfir-infrastructure)
## TL;DR

```console
helm install my-release oci://us-docker.pkg.dev/osdfir-registry/osdfir-charts/turbinia
```

## Introduction

This chart bootstraps a [Turbinia](https://github.com/google/turbinia/blob/master/docker/release/build/Dockerfile-latest) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

> **Note**: Due to Turbinia requiring additional permissions for attaching 
persistent disks, currently only Google Kubernetes Engine (GKE) and Local 
Kubernetes installations are supported at this time. See 
[GKE Installations](#gke-installations) for deploying to GKE.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://us-docker.pkg.dev/osdfir-registry/osdfir-charts/turbinia
```

To pull the chart locally:
```console
helm pull oci://us-docker.pkg.dev/osdfir-registry/osdfir-charts/turbinia
```

To install the chart from a local repo with the release name `my-release`:
```console
helm install my-release ../turbinia
```

The install command deploys Turbinia on the Kubernetes cluster in the default 
configuration without any resources defined. This is so we can increase the 
chances our chart runs on environments with little resources, such as Minikube. 
The [Parameters](#parameters) section lists the parameters that can be configured 
during installation or see [Installating for Production](#installing-for-production) 
for a recommended production installation.

> **Tip**:  You can override the default Turbinia configuration by placing the 
`turbinia.conf` config at the root of the Helm chart. When choosing this option, 
pull and install the Helm chart locally.

## Installing for Production

Pull the chart locally and review the `values.production.yaml` file for a list 
of values that will be overridden as part of this installation. 
```console
helm pull oci://us-docker.pkg.dev/osdfir-registry/osdfir-charts/turbinia
```

### GKE Installations
Please ensure that a Turbinia GCP service account has been created prior to 
installing the chart. You can use the helper script from the locally pulled 
chart in `tools/create-gcp-sa.sh` to automatically do this for you.

Install the chart providing both the original values and the production values,
and required GCP values with a release name `my-release`:
```console
helm install my-release ../turbinia \
    -f values.yaml 
    -f values-production.yaml 
    --set gcp.project=true
    --set gcp.projectID=<GCP_PROJECT_ID>
    --set gcp.projectRegion=<GKE_CLUSTER_REGION>
    --set gcp.projectZone=<GKE_ClUSTER_ZONE>
```

For non GCP production deployments, install the chart providing both the 
original values and the production values with a release name `my-release`:
```console
helm install my-release ../turbinia -f values.yaml -f values-production.yaml
```

To upgrade an existing release name `my-release` using production values, run:
```console
helm upgrade my-release -f values-production.yaml
```

Installing or upgrading a Turbinia deployment with `values-production.yaml` 
file will override a subset of values in the `values.yaml` file with a recommended
set of resources and replica pods needed for a production Turbinia installation
and deploys a GCP Filestore persistent volume for shared storage. For non GCP 
installations, please update the `persistence.storageClass` value with a 
storageClass supported by your provider.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```
> **Tip**: List all releases using `helm list`

The command removes all the Kubernetes components but PVC's associated with the chart and deletes the release.

To delete the PVC's associated with `my-release`:

```console
kubectl delete pvc -l release=my-release
```

> **Note**: Deleting the PVC's will delete Turbinia data as well. Please be cautious before doing it.

## Parameters

### Turbinia configuration


### Turbinia server configuration

| Name                            | Description                                                               | Value                                                                |
| ------------------------------- | ------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| `server.image.repository`       | Turbinia image repository                                                 | `us-docker.pkg.dev/osdfir-registry/turbinia/release/turbinia-server` |
| `server.image.pullPolicy`       | Turbinia image pull policy                                                | `IfNotPresent`                                                       |
| `server.image.tag`              | Overrides the image tag whose default is the chart appVersion             | `latest`                                                             |
| `server.image.imagePullSecrets` | Specify secrets if pulling from a private repository                      | `[]`                                                                 |
| `server.podSecurityContext`     | Holds pod-level security attributes and common server container settings  | `{}`                                                                 |
| `server.securityContext`        | Holds security configuration that will be applied to the server container | `{}`                                                                 |
| `server.resources.limits`       | Resource limits for the server container                                  | `{}`                                                                 |
| `server.resources.requests`     | Requested resources for the server container                              | `{}`                                                                 |
| `server.nodeSelector`           | Node labels for Turbinia server pods assignment                           | `{}`                                                                 |
| `server.tolerations`            | Tolerations for Turbinia server pods assignment                           | `[]`                                                                 |
| `server.affinity`               | Affinity for Turbinia server pods assignment                              | `{}`                                                                 |

### Turbinia worker configuration

| Name                                                | Description                                                                                                                                   | Value                                                                |
| --------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| `worker.image.repository`                           | Turbinia image repository                                                                                                                     | `us-docker.pkg.dev/osdfir-registry/turbinia/release/turbinia-worker` |
| `worker.image.pullPolicy`                           | Turbinia image pull policy                                                                                                                    | `IfNotPresent`                                                       |
| `worker.image.tag`                                  | Overrides the image tag whose default is the chart appVersion                                                                                 | `latest`                                                             |
| `worker.image.imagePullSecrets`                     | Specify secrets if pulling from a private repository                                                                                          | `[]`                                                                 |
| `worker.replicaCount`                               | Number of worker pods to run at once                                                                                                          | `5`                                                                  |
| `worker.autoscaling.enabled`                        | Enables Turbinia Worker autoscaling                                                                                                           | `true`                                                               |
| `worker.autoscaling.minReplicas`                    | Minimum amount of worker pods to run at once                                                                                                  | `5`                                                                  |
| `worker.autoscaling.maxReplicas`                    | Maximum amount of worker pods to run at once                                                                                                  | `500`                                                                |
| `worker.autoscaling.targetCPUUtilizationPercentage` | CPU scaling metric workers will scale based on                                                                                                | `80`                                                                 |
| `worker.podSecurityContext`                         | Holds pod-level security attributes and common worker container settings                                                                      | `{}`                                                                 |
| `worker.securityContext.privileged`                 | Runs the container as priveleged. Due to Turbinia attaching and detaching disks, a priveleged container is required for the worker container. | `true`                                                               |
| `worker.resources.limits`                           | Resources limits for the worker container                                                                                                     | `{}`                                                                 |
| `worker.resources.requests.cpu`                     | Requested cpu for the worker container                                                                                                        | `250m`                                                               |
| `worker.resources.requests.memory`                  | Requested memory for the worker container                                                                                                     | `256Mi`                                                              |
| `worker.nodeSelector`                               | Node labels for Turbinia worker pods assignment                                                                                               | `{}`                                                                 |
| `worker.tolerations`                                | Tolerations for Turbinia worker pods assignment                                                                                               | `[]`                                                                 |
| `worker.affinity`                                   | Affinity for Turbinia worker pods assignment                                                                                                  | `{}`                                                                 |

### Turbinia API / Web configuration

| Name                                         | Description                                                                  | Value                                                                    |
| -------------------------------------------- | ---------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| `api.image.repository`                       | Turbinia image repository for API / Web server                               | `us-docker.pkg.dev/osdfir-registry/turbinia/release/turbinia-api-server` |
| `api.image.pullPolicy`                       | Turbinia image pull policy                                                   | `IfNotPresent`                                                           |
| `api.image.tag`                              | Overrides the image tag whose default is the chart appVersion                | `latest`                                                                 |
| `api.image.imagePullSecrets`                 | Specify secrets if pulling from a private repository                         | `[]`                                                                     |
| `api.podSecurityContext.seccompProfile.type` | Deploys the default seccomp profile to the container                         | `RuntimeDefault`                                                         |
| `api.securityContext`                        | Holds security configuration that will be applied to the API / Web container | `{}`                                                                     |
| `api.resources.limits`                       | Resource limits for the api container                                        | `{}`                                                                     |
| `api.resources.requests`                     | Requested resources for the api container                                    | `{}`                                                                     |
| `api.nodeSelector`                           | Node labels for Turbinia api pods assignment                                 | `{}`                                                                     |
| `api.tolerations`                            | Tolerations for Turbinia api pods assignment                                 | `[]`                                                                     |
| `api.affinity`                               | Affinity for Turbinia api pods assignment                                    | `{}`                                                                     |

### Turbinia controller configuration

| Name                                | Description                                                                  | Value                                                                    |
| ----------------------------------- | ---------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| `controller.enabled`                | If enabled, deploys the Turbinia controller                                  | `false`                                                                  |
| `controller.image.repository`       | Turbinia image repository for the Turbinia controller                        | `us-docker.pkg.dev/osdfir-registry/turbinia/release/turbinia-controller` |
| `controller.image.pullPolicy`       | Turbinia image pull policy                                                   | `IfNotPresent`                                                           |
| `controller.image.tag`              | Overrides the image tag whose default is the chart appVersion                | `latest`                                                                 |
| `controller.image.imagePullSecrets` | Specify secrets if pulling from a private repository                         | `[]`                                                                     |
| `controller.podSecurityContext`     | Holds pod-level security attributes and common API / Web container settings  | `{}`                                                                     |
| `controller.securityContext`        | Holds security configuration that will be applied to the API / Web container | `{}`                                                                     |
| `controller.resources.limits`       | Resource limits for the controller container                                 | `{}`                                                                     |
| `controller.resources.requests`     | Requested resources for the controller container                             | `{}`                                                                     |
| `controller.nodeSelector`           | Node labels for Turbinia controller pods assignment                          | `{}`                                                                     |
| `controller.tolerations`            | Tolerations for Turbinia controller pods assignment                          | `[]`                                                                     |
| `controller.affinity`               | Affinity for Turbinia controller pods assignment                             | `{}`                                                                     |

### Common Parameters

| Name                              | Description                                                                                                                                                                                                          | Value                                                                                        |
| --------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| `nameOverride`                    | String to partially override names.fullname                                                                                                                                                                          | `""`                                                                                         |
| `fullnameOverride`                | String to fully override names.fullname                                                                                                                                                                              | `""`                                                                                         |
| `config.override`                 | Overrides the default Turbinia config to instead use a user specified config. Please ensure                                                                                                                          | `turbinia.conf`                                                                              |
| `config.disabledJobs`             | List of Turbinia Jobs to disable. Overrides DISABLED_JOBS in the Turbinia config.                                                                                                                                    | `['BinaryExtractorJob', 'BulkExtractorJob', 'HindsightJob', 'PhotorecJob', 'VolatilityJob']` |
| `gcp.enabled`                     | Enables Turbinia to run within a GCP project. When enabling, please ensure you have run the supplemental script `create-gcp-sa.sh` to create a Turbinia GCP service account required for attaching persistent disks. | `false`                                                                                      |
| `gcp.projectID`                   | GCP Project ID where your cluster is deployed. Required when `gcp.enabled` is set to true.                                                                                                                           | `""`                                                                                         |
| `gcp.projectRegion`               | Region where your cluster is deployed. Required when `gcp.enabled`` is set to true.                                                                                                                                  | `""`                                                                                         |
| `gcp.projectZone`                 | Zone where your cluster is deployed. Required when `gcp.enabled` is set to true.                                                                                                                                     | `""`                                                                                         |
| `gcp.gcpLogging`                  | Enables GCP Cloud Logging                                                                                                                                                                                            | `false`                                                                                      |
| `gcp.gcpErrorReporting`           | Enables GCP Cloud Error Reporting                                                                                                                                                                                    | `false`                                                                                      |
| `serviceAccount.create`           | Specifies whether a service account should be created                                                                                                                                                                | `true`                                                                                       |
| `serviceAccount.annotations`      | Annotations to add to the service account                                                                                                                                                                            | `{}`                                                                                         |
| `serviceAccount.name`             | The name of the service account to use                                                                                                                                                                               | `turbinia`                                                                                   |
| `service.type`                    | Turbinia service type                                                                                                                                                                                                | `ClusterIP`                                                                                  |
| `service.port`                    | Turbinia api service port                                                                                                                                                                                            | `8000`                                                                                       |
| `metrics.enabled`                 | Enables metrics scraping                                                                                                                                                                                             | `true`                                                                                       |
| `metrics.port`                    | Port to scrape metrics from                                                                                                                                                                                          | `9200`                                                                                       |
| `persistence.name`                | Turbinia persistent volume name                                                                                                                                                                                      | `turbiniavolume`                                                                             |
| `persistence.size`                | Turbinia persistent volume size                                                                                                                                                                                      | `8Gi`                                                                                        |
| `persistence.storageClass`        | PVC Storage Class for Turbinia volume                                                                                                                                                                                | `""`                                                                                         |
| `persistence.accessModes`         | PVC Access Mode for Turbinia volume                                                                                                                                                                                  | `["ReadWriteOnce"]`                                                                          |
| `ingress.enabled`                 | Enable the Turbinia loadbalancer for external access                                                                                                                                                                 | `false`                                                                                      |
| `ingress.host`                    | The domain name Turbinia will be hosted under                                                                                                                                                                        | `""`                                                                                         |
| `ingress.className`               | IngressClass that will be be used to implement the Ingress                                                                                                                                                           | `gce`                                                                                        |
| `ingress.gcp.managedCertificates` | Enabled GCP managed certificates for your domain                                                                                                                                                                     | `false`                                                                                      |
| `ingress.gcp.staticIPName`        | Name of the static IP address you reserved in GCP                                                                                                                                                                    | `""`                                                                                         |

### Third Party Configuration


### Redis configuration parameters

| Name                                | Description                                                                                  | Value       |
| ----------------------------------- | -------------------------------------------------------------------------------------------- | ----------- |
| `redis.enabled`                     | enabled Enables the Redis deployment                                                         | `true`      |
| `redis.sentinel.enabled`            | Enables Redis Sentinel on Redis pods                                                         | `false`     |
| `redis.master.count`                | Number of Redis master instances to deploy (experimental, requires additional configuration) | `1`         |
| `redis.master.service.type`         | Redis master service type                                                                    | `ClusterIP` |
| `redis.master.service.ports.redis`  | Redis master service port                                                                    | `6379`      |
| `redis.master.persistence.size`     | Persistent Volume size                                                                       | `8Gi`       |
| `redis.master.resources.limits`     | Resource limits for the Redis master containers                                              | `{}`        |
| `redis.master.resources.requests`   | Requested resources for the Redis master containers                                          | `{}`        |
| `redis.replica.replicaCount`        | Number of Redis replicas to deploy                                                           | `0`         |
| `redis.replica.service.type`        | Redis replicas service type                                                                  | `ClusterIP` |
| `redis.replica.service.ports.redis` | Redis replicas service port                                                                  | `6379`      |
| `redis.replica.persistence.size`    | Persistent Volume size                                                                       | `8Gi`       |
| `redis.replica.resources.limits`    | Resources limits for the Redis replica containers                                            | `{}`        |
| `redis.replica.resources.requests`  | Requested resources for the Redis replica containers                                         | `{}`        |

Specify each parameter using the --set key=value[,key=value] argument to helm install. For example,

```console
helm install my-release \
    --set metrics.port=9300
    oci://us-docker.pkg.dev/osdfir-registry/osdfir-charts/turbinia
```

The above command updates the Turbinia metrics port to `9300`.


Alternatively, the `values.yaml` file can be directly updated if the Helm chart 
was pulled locally. For example,

```console
helm pull oci://us-docker.pkg.dev/osdfir-registry/osdfir-charts/turbinia --untar
```

Then make changes to the downloaded `values.yaml`. A `turbinia.conf` config file
containing user-provided Turbinia config can also be placed at this point to override
the default one. Once done, install the local chart with the updated values.

```console
helm install my-release ../turbinia
```

Lastly, a YAML file that specifies the values for the parameters can also be provided while installing the chart. For example,

```console
helm install my-release -f newvalues.yaml oci://us-docker.pkg.dev/osdfir-registry/osdfir-charts/turbinia
```
## Persistence

The Turbinia deployment stores data at the `/mnt/turbiniavolume` path of the container and stores configuration files at the `/etc/turbinia` path of the container. 

Persistent Volume Claims are used to keep the data across deployments. By default the Turbinia deployment attempts to use dynamic persistent volume provisioning to automatically configure storage, but the `persistent.storageClass` value can be updated to a storageClass supported by your provider. See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

To install the Turbinia chart with more storage capacity, run:
```console
helm install my-release \
    --set persistence.size=10T
    oci://us-docker.pkg.dev/osdfir-registry/osdfir-charts/Turbinia
```

The above command installs the Turbinia chart with a persistent volume size of 10 Terabytes.

## Upgrading

If you need to upgrade an existing release to update a value in, such as
persistent volume size or upgrading to a new release, you can run 
[helm upgrade](https://helm.sh/docs/helm/helm_upgrade/). For example, to set a 
new release and upgrade storage capacity, run:
```console
helm upgrade my-release \
    --set image.tag=latest
    --set persistence.size=10T
```

The above command upgrades an existing release named `my-release` updating the
image tag to `latest` and increasing persistent volume size of an existing volume
to 10 Terabytes

## License

Copyright &copy; 2023 Turbinia

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.