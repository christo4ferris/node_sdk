# Self Contained Node.js Environment

This section describes how to setup a self contained evnironment for Node.js application development with the Hyperledget Fabric Node.js SDK. The setup uses **Docker** to provide controlled enviroment with all the necessary Hyperledger Fabric compoents to support a Node.js application. There are three **Docker** images that when run will provide a Block Chain network enviroment. There is an image to run as the **Peer**, one to run as the **Member Services** and one to run the Node application. The images come with a starter sample application ready to execute.

**note:** This sample was prepared using Docker for Mac 1.12.0

1. Prerequisite Software to install:
  * Docker
  * docker-compose (may be packaged with Docker)

2. Clone this repository

   ```
   git clone https://github.com/christo4ferris/node_sdk.git
   ```

3. Start the docker environment. From a terminal session in the working directory into which you cloned this repository, execute the following **docker-compose** command.

   ```
   docker-compose up -d
   ```

   This will start three docker containers, to view the container status try `docker ps` command. The first time this is run the **docker** images will be downloaded. This may take 10 minutess or more depending on the network connections of the system running the command.
      * Membership services --**membersrvc**
      * Peer --               **peer**
      * Node SDK Application -- **nodesdk**

3. Start a terminal session in the **nodesdk** container. This is where the Node.js application is located.  

   ```
   docker exec -it nodesdk /bin/bash
   ```

4. From the terminal session in the **nodesdk** container execute the standalone Node.js application. The docker terminal session should be in the working directory of the sample application called **app.js**  (*/opt/gopath/src/github.com/hyperledger/fabric/examples/sdk/node/example02*). Execute the following Node.js command to run the application.

   ```
   node app
   ```
   On another terminal session on the host you may wish to see the logs for the peer by executing the following command (not in the docker shell above, in a new terminal session of the real system)
   ```
   docker logs peer
   ```
5. If you wish to run your own Node.js application
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

6. To shutdown the enviroment, execute the following **docker-compose** command in the directory where the *docker-compose.yml* is located. Any changes you made to the sample application or deployment of a chain code will be lost. Only changes made to the shared area defined in the 'volumes' tag of the **nodesdk** container will persist.
   ```
   docker-compose down
   ```
  This will shutdown each of the containers and remove the containers from **docker**.

Next, see [Hyperledger Fabric Client (HFC) SDK for Node.js](node-sdk-indepth.md) to learn more about the SDK.
