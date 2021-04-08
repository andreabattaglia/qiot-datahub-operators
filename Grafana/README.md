# Grafana Operator Custom Resources

## Objects

### 10-grafana.yaml

Contains the Grafana instance, You need to edit the spec.config.security.admin_password

### 20-grafanadatasource.yaml

Contains the InfluxDB datasource, You need to edit the spec.datasources.[0].secureJsonData.token with a token generated in InfluxDB

### 10-grafana.yaml

Contains a Dasboard example with InfluxDB queries, also include two plugins.
