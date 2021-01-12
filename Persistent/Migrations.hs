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

main :: IO()
main = runSqlite ":memory:" $ do
    runMigration $ migrate entityDefs $ entityDef (Nothing :: Maybe Person)
    michaelId <- insert $ Person "Michael" $ Just 27
    michael <- get michaelId
    liftIO $ print michael