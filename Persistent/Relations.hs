{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE UndecidableInstances #-}

import Database.Persist
import Database.Persist.Sqlite
import Database.Persist.TH
import Data.Time
import Control.Monad.IO.Class (liftIO)

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Person
    name String
    age Int
    deriving Show
Car
    ownerId PersonId
    model String
    deriving Show
|]

main :: IO()
main = runSqlite ":memory:" $ do
    runMigration migrateAll
    bruce <- insert $ Person "Bruce Wayne" 30   -- bruce je ID osobe Bruce Wayne
    insert $ Car bruce "Bat Mobile"
    insert $ Car bruce "Porcshe"
    cars <- selectList [CarOwnerId ==. bruce] []    -- svi automobili Person-a bruce
    liftIO $ print cars