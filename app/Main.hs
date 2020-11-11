{-# LANGUAGE OverloadedStrings #-}
module Main where

import Adapter.Publisher (useProducer)
import Domain.Message (Key(..), Message(..))

main :: IO ()
main = do
  let key = Key "my-key"
      message = Message "message"
  useProducer key message
  
