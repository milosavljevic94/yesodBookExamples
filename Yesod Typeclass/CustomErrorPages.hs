-- primer iz knjige kako se barata sa errorHandler metodom i njeno overridovanje.
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
import Yesod

data App = App

mkYesod "App" [parseRoutes|
/ HomeR GET
/error ErrorR GET
/not-found NotFoundR GET
|]

instance Yesod App where
    errorHandler NotFound = fmap toTypedContent $ defaultLayout $ do
        setTitle "Request page not located"
        toWidget [hamlet|
            <h1>Not found
            <p>We apologize for the inconvenience, but the requested page could not be located.
        |]
    errorHandler other = defaultErrorHandler other

getHomeR :: Handler Html
getHomeR = defaultLayout
    [whamlet|
        <p>
            <a href=@{ErrorR}>Internal server error
            <a href=@{NotFoundR}>Not found
    |]

getErrorR :: Handler()
getErrorR = error "This is an error!"

getNotFoundR :: Handler()
getNotFoundR = notFound

main :: IO()
main = warp 3000 App