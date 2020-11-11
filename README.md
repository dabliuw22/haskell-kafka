# haskell-kafka

## Requirements
* `librdkafka` library.
* Stack.
* GHC.
* Docker.
* Kafka.

# Install `librdkafka`:
```
$ brew install librdkafka
```

## With Docker

1. Run Docker Compose file:
```
$ docker-compose up -d
```

2. Your IP:
* mac: `ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'`
* linux: `hostname -i | awk '{print $1}'`

3. List Topics:
```
$ docker exec -it my_haskell_kafka bash /opt/kafka/bin/kafka-topics.sh --list --zookeeper {IP}:2181
```
   
4. Create Consumer:
```
$ docker exec -it my_haskell_kafka bash /opt/kafka/bin/kafka-console-consumer.sh -bootstrap-server {IP}:9092 --topic haskell.t --from-beginning
```
    
6. Run Publisher App:
```
$ stack build
$ stack exec haskell-kafka-exe
```

## Dowload Apache Kafka

1. Dowload Apache Kafka.

2. Run Apache **Zookeeper**:
```
$ ./{KAFKA_PATH}/bin/zookeeper-server-start.sh ./config/zookeeper.properties
```

3. Run **Apache Kafka**:
```
$ ./{KAFKA_PATH}/bin/kafka-server-start.sh ./config/server.properties
```
    
4. Create `haskell.t`:
* With a Single partions:
```
$ ./{KAFKA_PATH}/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic haskell.t
```
* With multiple partitions:
```
$ ./{KAFKA_PATH}/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 3 --topic haskell.t
```
 
5. List Topics:
```
$ ./{KAFKA_PATH}/bin/kafka-topics.sh --list --zookeeper localhost:2181
```
   
6. Create Consumer:
```
$ ./{KAFKA_PATH}/bin/kafka-console-consumer.sh -bootstrap-server localhost:9092 --topic haskell.t --from-beginning
```

8. Run Publisher App:
```
$ stack build
$ stack exec haskell-kafka-exe
```