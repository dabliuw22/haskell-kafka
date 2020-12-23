# haskell-kafka

## Requirements
* `librdkafka` library.
* Stack.
* GHC.
* Docker.
* Kafka.

## Install `librdkafka`

### On Mac OS
```shell
$ brew install librdkafka
```

### On Linux (Debian, Ubuntu)
```shell
$ sudo apt-get install librdkafka-dev
```

## With Docker

### Run Docker Compose file
```shell
$ docker-compose up -d
```

### Your IP

#### On Mac OS
```shell 
$ ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'
```
#### On Linux (Debian, Ubuntu) 
```shell
$ hostname -i | awk '{print $1}'
```

### List Topics
```shell
$ docker exec -it my_haskell_kafka bash /opt/kafka/bin/kafka-topics.sh --list --zookeeper {IP}:2181
```

### Create Consumer
```shell
$ docker exec -it my_haskell_kafka bash /opt/kafka/bin/kafka-console-consumer.sh -bootstrap-server {IP}:9092 --topic haskell.t --from-beginning
```

### Run Publisher App
```shell
$ stack build
$ stack exec haskell-publisher-kafka-exe
```

### Run Consumer App
```shell
$ stack build
$ stack exec haskell-consumer-kafka-exe
```

## Dowload Apache Kafka

### Run Apache **Zookeeper**
```shell
$ ./{KAFKA_PATH}/bin/zookeeper-server-start.sh ./config/zookeeper.properties
```

### Run **Apache Kafka**
```shell
$ ./{KAFKA_PATH}/bin/kafka-server-start.sh ./config/server.properties
```

### Create `haskell.t`

#### With a Single partitions
```shell
$ ./{KAFKA_PATH}/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic haskell.t
```

#### With multiple partitions
```shell
$ ./{KAFKA_PATH}/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 3 --topic haskell.t
```

### List Topics
```shell
$ ./{KAFKA_PATH}/bin/kafka-topics.sh --list --zookeeper localhost:2181
```

### Create Consumer
```shell
$ ./{KAFKA_PATH}/bin/kafka-console-consumer.sh -bootstrap-server localhost:9092 --topic haskell.t --from-beginning
```

### Run Publisher App
```shell
$ stack build
$ stack exec haskell-publisher-kafka-exe
```

### Run Consumer App
```shell
$ stack build
$ stack exec haskell-consumer-kafka-exe
```