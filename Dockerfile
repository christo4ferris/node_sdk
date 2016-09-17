FROM hyperledger/fabric-peer:latest
RUN mkdir -p $GOPATH/src/chaincode_example02
WORKDIR $GOPATH/src/chaincode_example02
RUN sudo npm install --unsafe-perm -g hfc
RUN export NODE_PATH=/usr/local/lib/node_modules
RUN cp $GOPATH/src/github.com/hyperledger/fabric/examples/sdk/node/* .
COPY ./runme.sh .
COPY ./app.js .
RUN cp $GOPATH/src/github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02/chaincode_example02.go . && go build
