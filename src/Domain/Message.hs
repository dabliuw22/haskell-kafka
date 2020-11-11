module Domain.Message (Message (..), Key (..)) where

import Data.ByteString (ByteString)

newtype Key = Key ByteString

newtype Message = Message ByteString
