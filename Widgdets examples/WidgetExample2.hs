{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
import Yesod

data App = App

mkYesod "App" [parseRoutes|
/ HomeR GET
|]

instance Yesod App where

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    setTitle "toWidgetHead and toWidgetBody"
    toWidgetBody [hamlet|<script src=/included-in-body.js>|]
    toWidgetHead [hamlet|<script src=/included-in-head.js>|]

main :: IO()
main = warp 3000 App