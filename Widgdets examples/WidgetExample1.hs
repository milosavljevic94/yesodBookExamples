{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
import Yesod

data App = App
mkYesod "App" [parseRoutes|
/ HomeR GET
|]

instance Yesod App

getHomeR = defaultLayout $ do
    setTitle "My page tittle"
    toWidget [lucius| h1 {color: green;} |]
    addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"
    toWidget
        [julius|
        $(function() {
            $("h1").click(function(){
                alert("You clicked on heading!");
            });
        });
        |]
    toWidgetHead [hamlet|
        <meta name=keywords content="some sample keywords">
        |]
    toWidget [hamlet|
        <h1>Here's one way of including content
        |]
    [whamlet|<h2>Here's another |]
    toWidgetBody [julius|
        alert("This is included in body itself");
        |]

main = warp 3000 App