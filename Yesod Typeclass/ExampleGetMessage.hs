-- primer kako se koriste get i set message metode.
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
import Yesod
import Data.Time (getCurrentTime)

data App = App

mkYesod "App" [parseRoutes|
/ HomeR GET
|]

instance Yesod App where
    defaultLayout contents = do
        PageContent title headTags bodyTags <- widgetToPageContent contents
        mmsg <- getMessage
        withUrlRenderer [hamlet|
            $doctype 5

            <html>
            <head>
                <title>#{title}
                ^{headTags}
            <body>
                $maybe msg <- mmsg
                    <div #message>#{msg}
                ^{bodyTags}
        |]

getHomeR :: Handler Html
getHomeR = do
    now <- liftIO getCurrentTime
    setMessage $ toHtml $ "You previously visited at : " ++ show now
    defaultLayout [whamlet|<p>Try refreshing|]


main :: IO()
main = warp 3000 App