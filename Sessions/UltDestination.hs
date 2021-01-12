{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
import Yesod

data App = App

mkYesod "App" [parseRoutes|
/ HomeR GET
/setname SetNameR GET POST
/sayhello SayHelloR GET
|]

instance Yesod App

instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage

getHomeR :: Handler Html
getHomeR = defaultLayout [whamlet|
        <p>
            <a href=@{SetNameR}>Set your name
        <p>
            <a href=@{SayHelloR}>Say hello
    |]

-- Display the set name form
getSetNameR :: Handler Html
getSetNameR = defaultLayout [whamlet|
        <form method=post>
            My name is #
            <input type=text name=name>
            . #
            <input type=submit value="Set name">
    |]

-- Retrieve the submitted name from the user
postSetNameR :: Handler()
postSetNameR = do
    -- Get the submitted name and set it in the session
    name <- runInputPost $ ireq textField "name"
    setSession "name" name

    -- After we get a name, redirect to the ultimate destination.
    -- If no destination is set, default to the homepage
    redirectUltDest HomeR

getSayHelloR :: Handler Html
getSayHelloR = do
    mname <- lookupSession "name"   -- Lookup the name value set in the session
    case mname of
        Nothing -> do
                            -- No name in the session, set the current page as
                            -- the ultimate destination and redirect to the
                            -- SetName page
            setUltDestCurrent
            setMessage "Please tell me your name"
            redirect SetNameR
        Just name -> defaultLayout [whamlet|<p>Welcome #{name}|]

main :: IO()
main = warp 3000 App