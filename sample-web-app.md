# Node.js Web Application

The following is a web application template.  It is NOT a complete program.

This template code demonstrates how to communicate with a blockchain from a Node.js web application.  It does not show how to listen for incoming requests and how to authenticate your web users as this is application specific.  The code below is intended to demonstrate how to interact with a Hyperledger Fabric blockchain from an existing web application.

See the embedded comments below.

```javascript
/**
 * This example shows how to do the following in a web app.
 * 1) At initialization time, enroll the web app with the block chain.
 *    The identity must have already been registered.
 * 2) At run time, after a user has authenticated with the web app:
 *    a) register and enroll an identity for the user;
 *    b) use this identity to deploy, query, and invoke a chaincode.
 */
var hfc = require('hfc');

// Create a client chain.
// The name can be anything as it is only used internally.
var chain = hfc.newChain("targetChain");

// Configure the KeyValStore which is used to store sensitive keys
// as so it is important to secure this storage.
// The FileKeyValStore is a simple file-based KeyValStore, but you
// can easily implement your own to store whereever you want.
// To work correctly in a cluster, the file-based KeyValStore must
// either be on a shared file system shared by all members of the cluster
// or you must implement you own KeyValStore which all members of the
// cluster can share.
chain.setKeyValStore( hfc.newFileKeyValStore('/tmp/keyValStore') );

// Set the URL for membership services
chain.setMemberServicesUrl("grpc://localhost:7054");

// Add at least one peer's URL.  If you add multiple peers, it will failover
// to the 2nd if the 1st fails, to the 3rd if both the 1st and 2nd fails, etc.
chain.addPeer("grpc://localhost:7051");

// Enroll "WebAppAdmin" which is already registered because it is
// listed in fabric/membersrvc/membersrvc.yaml with its one time password.
// If "WebAppAdmin" has already been registered, this will still succeed
// because it stores the state in the KeyValStore
// (i.e. in '/tmp/keyValStore' in this sample).
chain.enroll("WebAppAdmin", "DJY27pEnl16d", function(err, webAppAdmin) {
   if (err) return console.log("ERROR: failed to register %s: %s",err);
   // Successfully enrolled WebAppAdmin during initialization.
   // Set this user as the chain's registrar which is authorized to register other users.
   chain.setRegistrar(webAppAdmin);
   // Now begin listening for web app requests
   listenForUserRequests();
});

// Main web app function to listen for and handle requests.  This is specific to
// your application but is provided here to demonstrate the pattern.
function listenForUserRequests() {
   for (;;) {
      // WebApp-specific logic goes here to await the next request.
      // ...
      // Assume that we received a request from an authenticated user
      // 'userName', and determined that we need to invoke the chaincode
      // with 'chaincodeID' and function named 'fcn' with arguments 'args'.
      handleUserRequest(userName,chaincodeID,fcn,args);
   }
}

// Handle a user request
function handleUserRequest(userName, chaincodeID, fcn, args) {
   // Register and enroll this user.
   // If this user has already been registered and/or enrolled, this will
   // still succeed because the state is kept in the KeyValStore
   // (i.e. in '/tmp/keyValStore' in this sample).
   var registrationRequest = {
        enrollmentID: userName,
        // Customize account & affiliation
        account: "bank_a",
        affiliation: "00001"
   };
   chain.registerAndEnroll( registrationRequest, function(err, user) {
      if (err) return console.log("ERROR: %s",err);
      // Issue an invoke request
      var invokeRequest = {
        // Name (hash) required for invoke
        chaincodeID: chaincodeID,
        // Function to trigger
        fcn: fcn,
        // Parameters for the invoke function
        args: args
     };
     // Invoke the request from the user object and wait for events to occur.
     var tx = user.invoke(invokeRequest);
     // Listen for the 'submitted' event
     tx.on('submitted', function(results) {
        console.log("submitted invoke: %j",results);
     });
     // Listen for the 'complete' event.
     tx.on('complete', function(results) {
        console.log("completed invoke: %j",results;
     });
     // Listen for the 'error' event.
     tx.on('error', function(err) {
        console.log("error on invoke: %j",err);
     });
   });
}
```
