module Domain.Message (Key (..), Event (..)) where

import Data.ByteString (ByteString)

newtype Key = Key ByteString

data Event
  = OneEvent {value :: String}
  | OtherEvent {number :: Int}
  deriving (Show)
