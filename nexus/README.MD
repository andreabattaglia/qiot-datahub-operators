# qiot-datahub-nexus

This helm chart installs a nexus artifact repository manager with username / password combination admin/admin123 in the current namespace. 

The implementation of the pipelines chart automatically makes use of this nexus repository.

## Building and installing the chart
```
$> helm package ./nexus -u
$> helm install qiot-covid19-datahub-nexus qiot-covid19-datahub-nexus-1.0.0.tgz
```

## changing defaults
All variables are in values.yaml --> NONE necessary!

