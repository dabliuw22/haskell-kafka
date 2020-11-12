module ConsumerKafka where

import Adapter.Subscriber (useConsumer)

main :: IO ()
main = useConsumer
