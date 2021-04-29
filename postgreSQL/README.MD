# Helm Chart to install PostgreSQL
This chart is installing a postgresql database into the namespace, based on the OpenShift template postgresql-persistent

## Building and installing the chart
```
$> helm package ./postgreSQL -u
$> helm install qiot-covid19-datahub-postgresql qiot-covid19-datahub-postgresql-1.0.0.tgz
```

## changing defaults
All variables are in values.yaml

