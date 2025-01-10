## notes


### Build & Run
Make sure you have docker daemon started.
It is recommended to have docker engine installed directly in wsl, without Docker or Racher Desktops.
Some users may fail to start nomad agent with Rancher Desktops, other may fail to get nomad jobs communicated with each other using Docker Desktop. 

```
mvn clean spring-boot:build-image -DskipTests

docker run -p 8080:8080 notes:0.0.1-SNAPSHOT
```

Run in Nomad cluster
```
// Create dir for postgres volume
sudo mkdir /home/tao/nomad/postgres-data

consul agent -config-file=nomad/consul.hcl

sudo nomad agent -config=nomad/nomad-server.hcl -config=nomad/nomad-client.hcl

nomad job run nomad/notes-postgres.nomad.hcl

nomad job run nomad/notes-flyway.nomad.hcl

nomad job run nomad/notes-web.nomad.hcl 

// See IP addresses
nomad node status -verbose
```

Open Nomad UI
http://localhost:4646/ui/jobs

Open Consul UI
http://localhost:8500

Open Notes
http://172.19.95.218:8080/

You can open Nomad dir with datadir and logs using Visual Code, make sure you use your user name:
```
code /home/tao/nomad
```
Note: you will not see the /home/tao/nomad/postgres-data because it requires sudo access to see it

Run in docker compose. Useful if you want to test your app and db fast:
```
docker compose -f docker-compose/docker-compose.yml up -d
```

References:
Nomad installation, cluster and job create, update, delete https://developer.hashicorp.com/nomad/tutorials/get-started/gs-overview
Consul installation https://developer.hashicorp.com/consul/install?product_intent=consul
consul-cni installation: `sudo apt install consul-cni`
CNI plugins installation https://developer.hashicorp.com/nomad/docs/networking/cni#cni-reference-plugins
Consul Service Mesh configs and requirements https://developer.hashicorp.com/nomad/docs/integrations/consul/service-mesh
Nomad Host Volume tutorial https://developer.hashicorp.com/nomad/tutorials/stateful-workloads/stateful-workloads-host-volumes
Consul -dev configs https://github.com/hashicorp/consul/blob/33e5727aac81d744f16ede69233b2e5fd95a0b75/agent/config/default.go#L172-L216
Nomad -dev configs https://github.com/hashicorp/nomad/blob/2bfe81772119f431fc75271d20aa7ca4fa3c1921/command/agent/config.go#L1324-L1378
Express inter-job dependencies with init tasks https://developer.hashicorp.com/nomad/tutorials/task-deps/task-dependencies-interjob

TODO:
I have problems reproducing and integrating dependencies with init tasks described in this tutorial https://developer.hashicorp.com/nomad/tutorials/task-deps/task-dependencies-interjob
I pushed both my integration and the tutorial files here https://github.com/GeneralTao2/notes/commit/526d5ebbf8babf25870c099bc966a7c4bb09d798
I keep getting `nslookup: can't resolve 'mock-service.service.consul'` in the await task logs in both my and tutorial deployament.
I tried tutorial deployment with both my cluster configs and the -dev configs like here
```
consul agent -dev -client=0.0.0.0
sudo nomad agent -dev-connect
nomad job run servicemesh.nomad.hcl
```
Yet, notes-flyway-task resolves notes-postgres-svc.service.consul

I managed to create image that allows exec in container using these configs for spring-boot-maven-plugin in configuration tag:
Plain Text
```
<image>
    <builder>paketobuildpacks/builder-jammy-full</builder>
    <env>
        <BP_JVM_VERSION>${java.version}</BP_JVM_VERSION>
    </env>
</image>
```

And looks like the DNS resolving works inside notes container
```
Plain Text
cnb@6087cf0e685f:/workspace$ nslookup notes-postgres-svc.service.consul
;; Got recursion not available from 172.22.180.137
Server:         172.22.180.137
Address:        172.22.180.137#53
Name:   notes-postgres-svc.service.consul
Address: 172.22.180.137
;; Got recursion not available from 172.22.180.137
```
