# InfluxDB v2 Helm chart

**Warning**: This InfluxDB Helm chart and the software it deploys are in a beta phase.

[InfluxDB](https://github.com/influxdata/influxdb) is an open source time series database with no external dependencies. It's useful for recording metrics, events, and performing analytics.

The InfluxDB v2 Helm chart uses the [Helm](https://helm.sh) package manager to bootstrap an InfluxDB v2 StatefulSet and service on a [Kubernetes](http://kubernetes.io) cluster.

## Prerequisites

- Helm v3 or later
- Kubernetes 1.4+
- (Optional) PersistentVolume (PV) provisioner support in the underlying infrastructure


## Building and installing the chart for the qIoT project
```
$> helm package ./influxdb2 -u
$> helm install qiot-covid19-datahub-influxdb2 qiot-covid19-datahub-influxdb2-1.0.0.tgz
```

## changing defaults
All variables are in values.yaml
