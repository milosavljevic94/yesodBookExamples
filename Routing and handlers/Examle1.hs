-- primer kada ruta prima argumente i prosledjuje ih handler funkciji
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE ViewPatterns #-}
import Data.Text (Text)
import qualified Data.Text as T
import Yesod

data App = App
instance Yesod App

mkYesod "App" [parseRoutes|
/person/#Text PersonR GET
/year/#Integer/month/#Text/day/#Int DateR
/wiki/*Texts WikiR GET
|]

getPersonR :: Text -> Handler Html
getPersonR name = defaultLayout[whamlet|<h1>Hello #{name}!!!|]

handleDateR :: Integer -> Text -> Int -> Handler Text
handleDateR y m d = 
    return $ T.concat ["Datum (dd/mm/yyyy): ", T.pack $ show d, " ", m, " ", T.pack $ show y]

getWikiR :: [Text] -> Handler Text
getWikiR = return . T.unwords

main :: IO ()
main = warp 3000 App