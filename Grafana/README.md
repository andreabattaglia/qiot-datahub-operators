# Grafana Operator Custom Resources

This deploy requires the Grafana Operator >=3.9 with grafana >=7.1 which comes fith Flux integration required for InfluxDB 2.0.

## Objects

### 10-grafana.yaml

Contains the Grafana instance, You need to edit the spec.config.security.admin_password.

### 20-grafanadatasource.yaml

Contains the InfluxDB datasource, You need to edit the spec.datasources.[0].secureJsonData.token with a token generated in InfluxDB.

### 10-grafana.yaml

Contains a Dasboard example with InfluxDB queries, also include two plugins.
