{-# LANGUAGE OverloadedStrings #-}

module Adapter.Subscriber (useConsumer) where

import Adapter.Json (FromJSON (..))
import Control.Exception (bracket)
import Control.Monad (replicateM_)
import Data.Aeson (decode)
import Data.ByteString (ByteString)
import Data.ByteString.Lazy (fromStrict)
import Domain.Message (Event (..))
import Kafka.Consumer

consumerProperties :: ConsumerProperties
consumerProperties =
  brokersList [BrokerAddress "localhost:9092"]
    <> logLevel KafkaLogInfo
    <> groupId (ConsumerGroupId "haskell.g")
    <> noAutoCommit

subscriptions :: Subscription
subscriptions = topics [TopicName "haskell.t"] <> offsetReset Earliest

useConsumer :: IO ()
useConsumer = do
  bracket acquire release use >>= print
  where
    acquire = newConsumer consumerProperties subscriptions
    release (Left _) = pure ()
    release (Right cons) = closeConsumer cons >> pure ()
    use (Left e) = pure $ Left e
    use (Right cons) = consume cons

consume :: KafkaConsumer -> IO (Either KafkaError ())
consume consumer = do
  replicateM_ 10 $ do
    msg <- pollMessage consumer (Timeout 1000)
    pollRecord msg
    status <- commitAllOffsets OffsetCommit consumer
    commit status
  return $ Right ()
  where
    pollRecord (Left (KafkaResponseError RdKafkaRespErrTimedOut)) = print "TimedOut"
    pollRecord (Left e) = print $ "Error: " <> show e
    pollRecord (Right (ConsumerRecord _ _ _ _ k v)) = print $ getEvent v
    commit (Just (KafkaResponseError RdKafkaRespErrNoOffset)) = print "NoOffset"
    commit (Just e) = print $ "Error: " <> show e
    commit _ = print "Success"

getEvent :: Maybe ByteString -> Maybe Event
getEvent bs = bs >>= \v -> decode (fromStrict v)
