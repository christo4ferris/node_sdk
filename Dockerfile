FROM hyperledger/fabric-peer:latest
WORKDIR $GOPATH/src/github.com/hyperledger/fabric/sdk/node
# this is temporary until sdk is built in the overall make
run make hfc
# This will install the HFC as a global nodejs package and setup 'hfc' command line
RUN sudo npm install --unsafe-perm -g
RUN export NODE_PATH=/usr/local/lib/node_modules
# now switch to the sample node app location when the shell is opened in the docker
RUN mkdir -p $GOPATH/src/sample
WORKDIR $GOPATH/src/chaincode_example02
# this is temporary until the app is in the examples
COPY ./app.js .
COPY ./runme.sh .
RUN cp $GOPATH/src/github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02/chaincode_example02.go . && go build
