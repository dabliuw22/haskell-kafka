{-# LANGUAGE OverloadedStrings #-}

module Adapter.Publisher where

import Data.Map (Map, fromList)
import Data.Text (Text)
import Kafka.Producer

extraProperties :: Map Text Text
extraProperties =
  fromList
    [ ("max.in.flight.requests.per.connection", "3"),
      ("client.id", "haskell.client"),
      ("enable.idempotence", "true"),
      ("batch.size", "500"),
      ("linger.ms", "10"),
      ("retries", "3")
    ]

producerProperties :: ProducerProperties
producerProperties =
  brokersList [BrokerAddress "localhost:9092"]
    <> logLevel KafkaLogInfo
    <> compression Snappy
    <> extraProps extraProperties
