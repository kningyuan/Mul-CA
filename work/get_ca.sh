#!/bin/bash

kill `ps -ef | grep fabric-ca-server | grep -v grep |awk '{print $2}'`

rm -rf fabric-ca-files/ init/ 
../bin/fabric-ca-server start -b admin:pass --cfg.affiliations.allowremove  --cfg.identities.allowremove -H ./init &
#mkdir -p init
#cd init 
#../../bin/fabric-ca-server  init -b user:user -H ./

read

../bin/fabric-ca-client enroll -u http://admin:pass@localhost:7054 -H `pwd`/fabric-ca-files/admin

read
../bin/fabric-ca-client  -H `pwd`/fabric-ca-files/admin  affiliation list
../bin/fabric-ca-client -H `pwd`/fabric-ca-files/admin  affiliation remove --force  org1
../bin/fabric-ca-client -H `pwd`/fabric-ca-files/admin  affiliation remove --force  org2

read
../bin/fabric-ca-client  -H `pwd`/fabric-ca-files/admin  affiliation add com
../bin/fabric-ca-client  -H `pwd`/fabric-ca-files/admin  affiliation add com.example
../bin/fabric-ca-client  -H `pwd`/fabric-ca-files/admin  affiliation add com.example.org1
../bin/fabric-ca-client  -H `pwd`/fabric-ca-files/admin  affiliation add com.example.org2
../bin/fabric-ca-client  -H `pwd`/fabric-ca-files/admin  affiliation list

read
mkdir -p fabric-ca-files/example.com/msp
../bin/fabric-ca-client getcacert -M `pwd`/fabric-ca-files/example.com/msp

mkdir -p fabric-ca-files/org1.example.com/msp
../bin/fabric-ca-client getcacert -M `pwd`/fabric-ca-files/org1.example.com/msp

mkdir -p fabric-ca-files/org2.example.com/msp
../bin/fabric-ca-client getcacert -M `pwd`/fabric-ca-files/org2.example.com/msp


echo "==========================="
read

cp ../fabric-ca-client-config.yaml  fabric-ca-files/admin/
../bin/fabric-ca-client register -H `pwd`/fabric-ca-files/admin --id.secret=user
../bin/fabric-ca-client enroll -u http://Admin@example.com:user@localhost:7054  -H `pwd`/fabric-ca-files/example.com/admin


../bin/fabric-ca-client affiliation list -H `pwd`/fabric-ca-files/example.com/admin
mkdir -p fabric-ca-files/example.com/msp/admincerts/
cp fabric-ca-files/example.com/admin/msp/signcerts/cert.pem  fabric-ca-files/example.com/msp/admincerts/


echo "=============org1============"
cp ../fabric-ca-client-config-org1.yaml  fabric-ca-files/admin/fabric-ca-client-config.yaml
../bin/fabric-ca-client register -H `pwd`/fabric-ca-files/admin --id.secret=user
../bin/fabric-ca-client enroll -u http://Admin@org1.example.com:user@localhost:7054  -H `pwd`/fabric-ca-files/org1.example.com/admin


../bin/fabric-ca-client affiliation list -H `pwd`/fabric-ca-files/org1.example.com/admin
mkdir -p fabric-ca-files/org1.example.com/msp/admincerts/
cp fabric-ca-files/org1.example.com/admin/msp/signcerts/cert.pem  fabric-ca-files/org1.example.com/msp/admincerts/



echo "=============org2============"
cp ../fabric-ca-client-config-org2.yaml  fabric-ca-files/admin/fabric-ca-client-config.yaml
../bin/fabric-ca-client register -H `pwd`/fabric-ca-files/admin --id.secret=user
../bin/fabric-ca-client enroll -u http://Admin@org2.example.com:user@localhost:7054  -H `pwd`/fabric-ca-files/org2.example.com/admin


../bin/fabric-ca-client affiliation list -H `pwd`/fabric-ca-files/org2.example.com/admin
mkdir -p fabric-ca-files/org2.example.com/msp/admincerts/
cp fabric-ca-files/org2.example.com/admin/msp/signcerts/cert.pem  fabric-ca-files/org1.example.com/msp/admincerts/



echo "=============orderer=========="
cp ../fabric-ca-client-config-orderer.yaml  fabric-ca-files/example.com/admin/fabric-ca-client-config.yaml
../bin/fabric-ca-client register -H `pwd`/fabric-ca-files/example.com/admin --id.secret=user
mkdir ./fabric-ca-files/example.com/orderer
../bin/fabric-ca-client enroll -u http://orderer.example.com:user@localhost:7054 -H `pwd`/fabric-ca-files/example.com/orderer
mkdir fabric-ca-files/example.com/orderer/msp/admincerts
cp fabric-ca-files/example.com/admin/msp/signcerts/cert.pem fabric-ca-files/example.com/orderer/msp/admincerts/


echo "=============peer0.org1=========="
cp ../fabric-ca-client-config-peer0.org1.yaml fabric-ca-files/org1.example.com/admin/fabric-ca-client-config.yaml
../bin/fabric-ca-client register -H `pwd`/fabric-ca-files/org1.example.com/admin --id.secret=user
mkdir -p ./fabric-ca-files/org1.example.com/peer0
../bin/fabric-ca-client enroll -u http://peer0.org1.example.com:user@localhost:7054 -H `pwd`/fabric-ca-files/org1.example.com/peer0
mkdir -p fabric-ca-files/org1.example.com/peer0/msp/admincerts
cp fabric-ca-files/org1.example.com/admin/msp/signcerts/cert.pem fabric-ca-files/org1.example.com/peer0/msp/admincerts/


echo "=============peer1.org1=========="
cp ../fabric-ca-client-config-peer1.org1.yaml fabric-ca-files/org1.example.com/admin/fabric-ca-client-config.yaml
../bin/fabric-ca-client register -H `pwd`/fabric-ca-files/org1.example.com/admin --id.secret=user
mkdir -p ./fabric-ca-files/org1.example.com/peer1
../bin/fabric-ca-client enroll -u http://peer1.org1.example.com:user@localhost:7054 -H `pwd`/fabric-ca-files/org1.example.com/peer1
mkdir -p fabric-ca-files/org1.example.com/peer1/msp/admincerts
cp fabric-ca-files/org1.example.com/admin/msp/signcerts/cert.pem fabric-ca-files/org1.example.com/peer1/msp/admincerts/



echo "=============peer0.org2=========="
cp ../fabric-ca-client-config-peer0.org2.yaml fabric-ca-files/org2.example.com/admin/fabric-ca-client-config.yaml
../bin/fabric-ca-client register -H `pwd`/fabric-ca-files/org2.example.com/admin --id.secret=user
mkdir -p ./fabric-ca-files/org2.example.com/peer0
../bin/fabric-ca-client enroll -u http://peer0.org2.example.com:user@localhost:7054 -H `pwd`/fabric-ca-files/org2.example.com/peer0
mkdir -p fabric-ca-files/org2.example.com/peer0/msp/admincerts
cp fabric-ca-files/org2.example.com/admin/msp/signcerts/cert.pem fabric-ca-files/org2.example.com/peer0/msp/admincerts/


echo "=============peer1.org2=========="
cp ../fabric-ca-client-config-peer1.org2.yaml fabric-ca-files/org2.example.com/admin/fabric-ca-client-config.yaml
../bin/fabric-ca-client register -H `pwd`/fabric-ca-files/org2.example.com/admin --id.secret=user
mkdir -p ./fabric-ca-files/org2.example.com/peer1
../bin/fabric-ca-client enroll -u http://peer1.org2.example.com:user@localhost:7054 -H `pwd`/fabric-ca-files/org2.example.com/peer1
mkdir -p fabric-ca-files/org2.example.com/peer1/msp/admincerts
cp fabric-ca-files/org2.example.com/admin/msp/signcerts/cert.pem fabric-ca-files/org2.example.com/peer1/msp/admincerts/

