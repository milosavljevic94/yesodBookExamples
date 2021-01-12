{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralisedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE UndecidableInstances #-}
import Control.Monad.IO.Class (liftIO)
import Database.Persist
import Database.Persist.Sqlite
import Database.Persist.TH
import Control.Monad.IO.Unlift
import Data.Text
import Control.Monad.Reader
import Control.Monad.Logger
import Conduit

share [mkPersist sqlSettings, mkSave "entityDefs"] [persistLowerCase|
Person
    name String
    age Int Maybe
    deriving Show
|]

runSqlite' :: (MonadUnliftIO m) => Text -> ReaderT SqlBackend (NoLoggingT (ResourceT m)) a -> m a
runSqlite' = runSqlite

main :: IO()
main = runSqlite' ":memory:" $ do
    michaelId <- insert $ Person "Michael" $ Just 26
    michael <- get michaelId
    liftIO $ print michael