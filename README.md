## notes


### Build & Run
Make sure you have docker daemon started.
```
mvn clean spring-boot:build-image -DskipTests
docker run -p 8080:8080 notes:0.0.1-SNAPSHOT
```

```
mvn clean spring-boot:build-image -DskipTests
docker run -p 8080:8080 notes:0.0.1-SNAPSHOT
```

Run in Nomad dev cluster
```
sudo nomad agent -dev \
-bind 0.0.0.0 \
-network-interface='{{ GetDefaultInterfaces | attr "name" }}'
nomad job run nomad/notes-web.nomad.hcl 
```
