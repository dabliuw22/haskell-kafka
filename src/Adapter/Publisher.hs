{-# LANGUAGE OverloadedStrings #-}

module Adapter.Publisher (useProducer) where

import Control.Exception (bracket)
import Data.Map (Map, fromList)
import Data.Text (Text)
import Domain.Message (Key(..), Message(..))
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

topic :: TopicName
topic = TopicName "haskell.t"

makeRecord :: Key -> Message -> ProducerRecord
makeRecord (Key k) (Message m) =
  ProducerRecord {
    prTopic = topic,
    prPartition = UnassignedPartition,
    prKey = Just k,
    prValue = Just m
  }

useProducer :: Key -> Message -> IO ()
useProducer key message =
  bracket acquire release use >>= print
  where
    acquire = newProducer producerProperties
    release (Left _) = pure ()
    release (Right prod) = closeProducer prod
    use (Left e) = pure $ Left e
    use (Right prod) = send prod key message


send :: KafkaProducer -> Key -> Message -> IO (Either KafkaError ())
send producer key message = do
  let record = makeRecord key message
  result <- produceMessage producer record
  case result of
    Just e -> return $ Left e
    _      -> return $ Right ()

