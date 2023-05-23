# mongo-db-cluster

## KEYFILES
openssl rand -base64 756 > mongo-keyfile
sudo mkdir /opt/mongo
sudo mv ~/mongo-keyfile /opt/mongo
sudo chmod 400 /opt/mongo/mongo-keyfile
sudo chown mongodb:mongodb /opt/mongo/mongo-keyfile
sudo nano /etc/mongod.conf
keyFile: /opt/mongo/mongodb-keyfile

## INIT CONFIG REPLICA SETS
mongo
use admin
db.createUser({user: "mongo-admin", pwd: "jdA0B64dhP73F", roles:[{role: "root", db: "admin"}]})
sudo nano /etc/mongod.conf
mongo 10.0.0.3:27017 -u mongo-admin -p jdA0B64dhP73F --authenticationDatabase admin
rs.initiate( { _id: "config-rs", configsvr: true, members: [ { _id: 0, host: "10.0.0.3:27017" }, { _id: 1, host: "10.0.0.4:27017" }, { _id: 2, host: "10.0.0.5:27017" } ] } )
rs.status()

## INIT SHARD REPLICA SETS
mongo 10.0.0.6:27017 -u mongo-admin -p jdA0B64dhP73F --authenticationDatabase admin
rs.initiate({ _id : "shard-rs0", members: [ { _id : 0, host : "10.0.0.6:27017" } ] })
mongo 10.0.0.7:27017 -u mongo-admin -p jdA0B64dhP73F --authenticationDatabase admin
rs.initiate({ _id : "shard-rs1", members: [ { _id : 0, host : "10.0.0.7:27017" } ] })

## ADD SHARDS
mongo 10.0.0.2:27017 -u mongo-admin -p jdA0B64dhP73F --authenticationDatabase admin
sh.addShard("shard-rs0/10.0.0.6:27017")
sh.addShard("shard-rs1/10.0.0.7:27017")

## CREATE DATABASE
use mydb
sh.enableSharding("activityrank")
db.createCollection("guilds")
db.createCollection("users")
db.createCollection("shards")
sh.shardCollection("mydb.guilds", { _id : "hashed" } )
sh.shardCollection("mydb.users", { _id : "hashed" } )
sh.shardCollection("mydb.shards", { _id : "hashed" } )
