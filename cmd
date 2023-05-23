openssl rand -base64 756 > mongo-keyfile
sudo mkdir /opt/mongo
sudo mv ~/mongo-keyfile /opt/mongo
sudo chmod 400 /opt/mongo/mongo-keyfile
sudo chown mongodb:mongodb /opt/mongo/mongo-keyfile
sudo nano /etc/mongod.conf
keyFile: /opt/mongo/mongodb-keyfile

// INIT CONFIG REPLICA SETS
mongo
use admin
db.createUser({user: "mongo-admin", pwd: "jdA0B64dhP73F", roles:[{role: "root", db: "admin"}]})
sudo nano /etc/mongod.conf
mongo 10.0.0.3:27017 -u mongo-admin -p jdA0B64dhP73F --authenticationDatabase admin
rs.initiate( { _id: "config-rs", configsvr: true, members: [ { _id: 0, host: "10.0.0.3:27017" }, { _id: 1, host: "10.0.0.4:27017" }, { _id: 2, host: "10.0.0.5:27017" } ] } )
rs.status()

// INIT SHARD REPLICA SETS
mongo 10.0.0.6:27017 -u mongo-admin -p jdA0B64dhP73F --authenticationDatabase admin
rs.initiate({ _id : "shard-rs0", members: [ { _id : 0, host : "10.0.0.6:27017" } ] })
mongo 10.0.0.7:27017 -u mongo-admin -p jdA0B64dhP73F --authenticationDatabase admin
rs.initiate({ _id : "shard-rs1", members: [ { _id : 0, host : "10.0.0.7:27017" } ] })

// ADD SHARDS
mongo 10.0.0.2:27017 -u mongo-admin -p jdA0B64dhP73F --authenticationDatabase admin
sh.addShard("shard-rs0/10.0.0.6:27017")
sh.addShard("shard-rs1/10.0.0.7:27017")

// CREATE DATABASE
use activityrank
sh.enableSharding("activityrank")
db.createCollection("guilds")
db.createCollection("users")
db.createCollection("shards")
sh.shardCollection("activityrank.guilds", { _id : "hashed" } )
sh.shardCollection("activityrank.users", { _id : "hashed" } )
sh.shardCollection("activityrank.shards", { _id : "hashed" } )

// KEYFILE
soEshFV3XgDBueZELs7JOWNJ424UWfhnDbxdRR8QV5zsjeP++UeyKxw+SmAdvx3e
xxITfKpDbEybZ0baN1Cv+WkOpV3QJoCnCuTf4zM8c0SQlrRBJJ0dTkRJfCb7glQw
vDuskJWuUPnqLjccaeVYk8v7bjfq4IZKW55GyzYCRZW6iMfo3KTPClG0pxIsHPpm
UemurNBEvs/FHVIeb6CoYrVgynZrQZWA85kXOyirYBuzwpPOW2o/0aPaNFbQp3iF
QZmAuIu8n+kU4vUIWV1zU9t/qxDsVH5Wg4aFPYkZsJzc9YTxZNNxJUflPgpUGyPP
62W78eqU4ePS/fLjnTboPVd+RkHz3E0HbZp/44Om79pjTt3o3/RoMLZxbxs6asAf
RGwslsfRuNIhfFMRBqeWeafUoItm85xG+uz5M89R1kq4PuO7WqVHBgC5yGOiMyKL
LUOfHqzFDH1Xx3GEFUmI/zO4+UZhLS1tlkrbgPdJN2fwPXJM4OdKakvlGR2ulcm7
GFk4hJLWtLL+JFClBVWB3tJKLEFR6CmxEbmE3wjCa/o9kjFId4xgTtUDYOPx+7Gz
8QNq+ed3yONPVMVbj4IWyCN/0HGqXIbHit3E2xWA5x+dVgb/ukRb4quyWG+Y8vam
FE8ojlWe5s2HydFGU8Awerfv9F9gjzqpbwdkEQlw22Ey0FatOGT7GzbyrwrlDNlbDDKs
/tvmPHJHz1KTNy2Kvfs+805UYUbz78qyxXAVONJ/CEMHo1YtTw+whfZCZAksgb+c
GHi9xNRKEWV2gtmQVsq1YvhlS0BnDCrp01JkABNvgfnOxfwMKXAWctiHJNxaVPeJ
knPgBJACLm5kxEcCa6fwkWsfyeC2kXAaGbCfQUCynOhZj2Dz3EjfLlsPAzUPWLr8
fBQyVtx5AXiY9IFpM93yTozi+qGO5bd8xdoCE2PmZHjAxtj1d4s8SZ8hKwHOP4PJ
SQTrqYFMKGtsKTkx1F6Nch4B7DuZjv/AxCDoklMKZnS/ceUc
