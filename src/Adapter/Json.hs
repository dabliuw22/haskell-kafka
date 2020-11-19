{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE OverloadedStrings #-}

module Adapter.Json (ToJSON (..), FromJSON (..)) where

import Control.Monad (mzero)
import Data.Aeson
  ( FromJSON (..),
    Object,
    ToJSON (..),
    Value (..),
    object,
    withObject,
    (.:),
    (.=),
  )
import Data.Aeson.Types (Parser)
import Domain.Message (Event (..))

instance ToJSON Event where
  toJSON (OneEvent val) = object ["_type" .= String "OneEvent", "value" .= val]
  toJSON (OtherEvent num) = object ["_type" .= String "OtherEvent", "number" .= num]

instance FromJSON Event where
  parseJSON = withObject "Event" $ \obj -> do
    _type <- obj .: "_type"
    case (_type :: String) of
      "OneEvent" -> fromOneEvent obj
      "OtherEvent" -> fromOtherEvent obj
      _ -> mzero --fail "Invalid"
    where
      fromOneEvent :: Object -> Parser Event
      fromOneEvent o = do
        val <- o .: "value"
        return $ OneEvent val
      fromOtherEvent :: Object -> Parser Event
      fromOtherEvent o = do
        num <- o .: "number"
        return $ OtherEvent (num :: Int)
