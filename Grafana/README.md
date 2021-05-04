# Helm Chart to install and configure Grafana for the qIoT project
This chart installs Grafana Community Operator and configures it so that it will make use of the
allready installed [InfluxDB2](../influxdb2/README.md) and [PostgreSQL](../postgreSQL/README.md)  

## Building and installing the chart
```
$> helm package ./Grafana -u
$> helm install qiot-covid19-datahub-grafana qiot-covid19-datahub-grafana-1.0.0.tgz
```

## changing defaults
All variables are in values.yaml


## Grafana Operator Custom Resources
This deploy requires the Grafana Operator >=3.9 with grafana >=7.1 which comes with Flux integration required for InfluxDB 2.0.

### 10-grafana.yaml
Contains the Grafana instance, You need to edit the spec.config.security.admin_password.


### 20-grafanadatasource.yaml
Contains the InfluxDB datasource, You need to edit the spec.datasources.[0].secureJsonData.token with a token generated in InfluxDB.


### 10-grafana.yaml
Contains a Dasboard example with InfluxDB queries, also include two plugins.
