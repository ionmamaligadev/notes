## notes


### Build & Run
Make sure you have docker daemon started.
```
mvn package jib:dockerBuild
docker run -p 8080:8080 notes
```
