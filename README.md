## notes


### Build & Run
Make sure you have docker daemon started.
```
mvn clean spring-boot:build-image -DskipTests
docker run -p 8080:8080 notes:0.0.1-SNAPSHOT
```
