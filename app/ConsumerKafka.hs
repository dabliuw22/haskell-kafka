module ConsumerKafka where

import Adapter.Subscriber (useConsumer)
import Control.Monad (forever)

main :: IO ()
main = forever useConsumer
