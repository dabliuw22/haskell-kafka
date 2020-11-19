{-# LANGUAGE OverloadedStrings #-}

module PublisherKafka where

import Adapter.Publisher (useProducer)
import Domain.Message (Event (..), Key (..))

main :: IO ()
main = do
  let key = Key "my-key"
      event = OneEvent "MyValue"
  useProducer key event
