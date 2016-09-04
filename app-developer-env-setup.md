# Setting up the Full Hyperledger Fabric Developer's Environment

1. See [Setting Up The Development Environment](../dev-setup/devenv.md) to set up your development environment.

2. Issue the following commands to build the Node.js Client SDK including the API reference documentation  

   ```
   cd /opt/gopath/src/github.com/hyperledger/fabric
   make node-sdk
   ```
3. Issue the following commands to set the HFC as a Node.js global package available to your Node.js application with the `require("hfc")`.  

   ```
   cd /opt/gopath/src/github.com/hyperledger/fabric/sdk/node
   sudo npm install --unsafe-perm -g
   ```   
4. To see the API reference documentation which is built when the above 'make node-sd' runs
   ```
   cd /opt/gopath/src/github.com/hyperledger/fabric/sdk/node/doc
   ```

Next, see [Running a Sample Application](sample-standalone-app.md) to run a sample standalone application and to begin to learn how to use the Node.js Client SDK.
