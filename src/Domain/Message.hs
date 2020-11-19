module Domain.Message (Message (..), Key (..), Event (..)) where

import Data.ByteString (ByteString)

newtype Key = Key ByteString

newtype Message = Message ByteString

data Event
  = OneEvent {value :: String}
  | OtherEvent {number :: Int}
  deriving (Show)
