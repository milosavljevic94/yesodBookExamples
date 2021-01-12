{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE StandaloneDeriving         #-}
{-# LANGUAGE UndecidableInstances       #-}

import Database.Persist.TH
import Data.Text (Text)
import Database.Persist.Sqlite
import Control.Monad.IO.Class (liftIO)
import Data.Conduit
import qualified Data.Conduit.List as CL

share[mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Person
    name Text
|]

main :: IO()
main = runSqlite ":memory:" $ do
    runMigration migrateAll
    
    insert $ Person "Michael Snoyman"
    insert $ Person "Miriam Snoyman"
    insert $ Person "Eliezer Snoyman"
    insert $ Person "Gavriella Snoyman"
    insert $ Person "Greg Weber"
    insert $ Person "Rick Richardson"

    let sql = "SELECT name FROM Person WHERE name LIKE '%Snoyman'"
    runConduit(rawQuery sql [] .| CL.mapM_ (liftIO . print))