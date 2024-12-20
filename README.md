## notes


### Build & Run
Make sure you have docker daemon started.
```
mvn clean spring-boot:build-image -DskipTests

docker run -p 8080:8080 notes:0.0.1-SNAPSHOT
```

Run in Nomad cluster
```
nomad agent -config=nomad/nomad-server.hcl -config=nomad/nomad-client.hcl

nomad job run nomad/notes-web.nomad.hcl 

nomad node status -verbose \
    $(nomad job allocs notes-web-job | grep -i running | awk '{print $2}') | \
    grep -i ip-address | awk -F "=" '{print $2}' | xargs | \
    awk '{print "http://"$1":8080"}'
```

Open Nomad dir with datadir and logs using Visual Code:
```
code /tmp/nomad
```
