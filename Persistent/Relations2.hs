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

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Person
    name String
Store
    name String
PersonStore
    personId PersonId
    storeId StoreId
    UniquePersonStore personId storeId
|]

main :: IO()
main = runSqlite ":memory:" $ do
    runMigration migrateAll

    bruce <- insert $ Person "Bruce Wayne"
    michael <- insert $ Person "Michael"

    prada <- insert $ Store "Prada"
    gucci <- insert $ Store "Gucci"
    versace <- insert $ Store "Versace"

    insert $ PersonStore bruce prada
    insert $ PersonStore bruce versace

    insert $ PersonStore michael gucci
    insert $ PersonStore michael versace

    return()