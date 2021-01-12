{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
import Yesod

data App = App
mkYesod "App" [parseRoutes|
/ HomeR GET
|]

myLayout :: Widget -> Handler Html
myLayout widget = do
    pc <- widgetToPageContent widget
    withUrlRenderer
        [hamlet|
            $doctype 5
            <html>
                <head>
                    <title>#{pageTitle pc}
                    <meta charset=utf-8>
                    <style>body {font-family: verdana}
                    ^{pageHead pc}
                <body>
                    <article>
                        ^{pageBody pc}
        |]

{- Mala napomena ako imamo komplikovanije style tagove. 
Ponovo postavimo do notaciju pre withUrlRenderer i definisemo stil uz pomoc lucius ili cassius.

myLayout :: Widget -> Handler Html
myLayout widget = do
    pc <- widgetToPageContent do $ 
        widget
        toWidget[lucius| body { font-family: verdana } |]
    withUrlRenderer
        [hamlet|
            $doctype 5
            <html>
                <head>
                    <title>#{pageTitle pc}
                    <meta charset=utf-8>
                    ^{pageHead pc}
                <body>
                    <article>
                        ^{pageBody pc}
        |]

-}

instance Yesod App where
    defaultLayout = myLayout

getHomeR :: Handler Html
getHomeR = defaultLayout [whamlet|
    <p>Hello world!
|]

main :: IO()
main = warp 3000 App