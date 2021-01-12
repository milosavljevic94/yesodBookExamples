{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
import Control.Exception (IOException, try)
import Control.Monad (when)
import Yesod

data App = App

instance Yesod App where
    shouldLogIO App src level =     -- This function controls which messages are logged
        return True                 -- good for development
                                    -- level == LevelWarn || level == LevelError -- good for production
mkYesod "App" [parseRoutes|
/ HomeR GET
|]

getHomeR :: Handler Html
getHomeR = do
    $logDebug "Trying to read data file"
    edata <- liftIO $ try $ readFile "dataFile.txt"
    case edata :: Either IOException String of
        Left e -> do
            $logError "Could not read dataFile.txt"
            defaultLayout[whamlet|An error occurred|]
        Right str -> do
            $logInfo "Reading of dataFile.txt succeeded"
            let ls = lines str
            when (length ls < 5) $ $logWarn "Less then 5 lines of data!"
            defaultLayout[whamlet|
                <ol>
                    $forall l <- ls
                        <li>#{l}
            |]

main :: IO()
main = warp 3000 App