# Self Contained Node.js Environment

This section describes how to setup a self contained evnironment for Node.js application development with the Hyperledget Fabric Node.js SDK. The setup uses **Docker** to provide controlled enviroment with all the necessary Hyperledger Fabric compoents to support a Node.js application. There are three **Docker** images that when run will provide a Block Chain network enviroment. There is an image to run as the **Peer**, one to run as the **Member Services** and one to run the Node application. The images come with a starter sample application ready to execute.

**note:** This sample was prepared using Docker for Mac 1.12.0

1. Prerequisite Software to install:
  * Docker
  * docker-compose (may be packaged with Docker)

2. Create a docker-compose file called *docker-compose.yml*

   ```yaml
membersrvc:
  # try 'docker ps' to see the container status after starting this compose
  container_name: membersrvc
  image: hyperledger/fabric-membersrvc
  command: membersrvc

peer:
  container_name: peer
  image: hyperledger/fabric-peer
  environment:
    - CORE_PEER_ADDRESSAUTODETECT=true
    - CORE_VM_ENDPOINT=unix:///var/run/docker.sock
    - CORE_LOGGING_LEVEL=DEBUG
    - CORE_PEER_ID=vp0
    - CORE_SECURITY_ENABLED=true
    - CORE_PEER_PKI_ECA_PADDR=membersrvc:7054
    - CORE_PEER_PKI_TCA_PADDR=membersrvc:7054
    - CORE_PEER_PKI_TLSCA_PADDR=membersrvc:7054
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock
  # have the peer wait 10 sec for membersrvc to start
  #  the following is to run the peer in Developer mode - also set nodesdk DEPLOY_MODE=dev
  command: sh -c "sleep 10; peer node start --peer-chaincodedev"
  #  the following is to run the peer in Network mode - also set the nodesdk DEPLOY_MODE=net
  # command: sh -c "sleep 10; peer node start"
  links:
    - membersrvc

nodesdk:
  container_name: nodesdk
  image: hyperledger/fabric-node-sdk
  volumes:
    - ~/mytest:/user/mytest
  environment:
    - MEMBERSRVC_ADDRESS=membersrvc:7054
    - PEER_ADDRESS=peer:7051
    - KEY_VALUE_STORE=/tmp/hl_sdk_node_key_value_store
    - NODE_PATH=/usr/local/lib/node_modules
    # set to following to 'dev' if peer running id Developer mode
    - DEPLOY_MODE=dev
  command: bash
  stdin_open: true
  tty: true
  links:
    - membersrvc
    - peer

   ```

3. Start the docker environment. From a terminal session where the working directory is where the above yaml file is located, execute one of following **docker-compose** commands.

   * to run as detached containers, then to see the logs for the **peer** container use the `docker logs peer` command
   ```
   docker-compose up -d
   ```
   * to run in the foreground and see the log output in current terminal session
   ```
   docker-compose up
   ```

   This will start three docker containers, to view the container status try `docker ps` command. The first time this is run the **docker** images will be downloaded. This may take 10 minutess or more depending on the network connections of the system running the command.
      * Membership services --**membersrvc**
      * Peer --               **peer**
      * Node SDK Application -- **nodesdk**

4. Start a terminal session in the **nodesdk** container. This is where the Node.js application is located.  

   ```
   docker exec -it nodesdk /bin/bash
   ```

5. From the terminal session in the **nodesdk** container execute the standalone Node.js application. The docker terminal session should be in the working directory of the sample application called **app.js**  (*/opt/gopath/src/github.com/hyperledger/fabric/examples/sdk/node/example02*). Execute the following Node.js command to run the application.

   ```
   node app
   ```
   On another terminal session on the host you may wish to see the logs for the peer by executing the following command (not in the docker shell above, in a new terminal session of the real system)
   ```
   docker logs peer
   ```
6. If you wish to run your own Node.js application
   * use the directories in the `volumes` tag under **nodesdk** in the `docker-compose.yml` file as a place to store your programs from the host system into the docker container. The first path is on the top level system (host system) and the second is created in the docker container. If you wish to use a host location that is not under the `/Users` dirctory (`~` is under `/Users') then you must add that to the **docker** file sharing under **docker** preferences. 
   ```yaml
  volumes:
    - ~/mytest:/user/mytest
   ```
   * copy or create and edit your application in the `~/mytest` directory as stated in the `docker-compose.yml` `volumes` tag under **nodesdk** container.
   * run the application from within the **nodesdk** docker container using the commands
   ```
   docker exec -it nodesdk /bin/bash
   ```
   once in the shell, and assuming your Node.js application is called `app.js`
   ```
   cd /user/mytest
   node app
   ```   

7. To shutdown the enviroment, execute the following **docker-compose** command in the directory where the *docker-compose.yml* is located. Any changes you made to the sample application or deployment of a chain code will be lost. Only changes made to the shared area defined in the 'volumes' tag of the **nodesdk** container will persist.
   ```
   docker-compose down
   ```
  This will shutdown each of the containers and remove the containers from **docker**.

Next, see [Hyperledger Fabric Client (HFC) SDK for Node.js](node-sdk-indepth.md) to learn more about the SDK.
