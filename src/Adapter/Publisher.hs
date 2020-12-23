{-# LANGUAGE OverloadedStrings #-}

module Adapter.Publisher (useProducer) where

import Adapter.Json (ToJSON (..))
import Control.Exception (bracket)
import Data.Aeson (encode)
import Data.ByteString.Lazy (toStrict)
import Data.Map (Map, fromList)
import Data.Text (Text)
import Domain.Message (Event (..), Key (..))
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

makeRecord :: Key -> Event -> ProducerRecord
makeRecord (Key k) e =
  ProducerRecord
    { prTopic = topic,
      prPartition = UnassignedPartition,
      prKey = Just k,
      prValue = Just $ toStrict (encode e)
    }

useProducer :: Key -> Event -> IO ()
useProducer key event =
  bracket acquire release use >>= print
  where
    acquire :: IO (Either KafkaError KafkaProducer)
    acquire = newProducer producerProperties
    release :: Either KafkaError KafkaProducer -> IO ()
    release (Left _) = pure ()
    release (Right prod) = closeProducer prod
    use :: Either KafkaError KafkaProducer -> IO (Either KafkaError ())
    use (Left e) = pure $ Left e
    use (Right prod) = send prod key event

send :: KafkaProducer -> Key -> Event -> IO (Either KafkaError ())
send producer key event = do
  let record = makeRecord key event
  result <- produceMessage producer record
  case result of
    Just e -> return $ Left e
    _ -> return $ Right ()
