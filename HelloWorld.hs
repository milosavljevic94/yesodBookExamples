{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE QuasiQuotes  #-}
{-# LANGUAGE TemplateHaskell  #-}
{-# LANGUAGE TypeFamilies  #-}
import          Yesod

data HelloWorld = HelloWorld
                                        -- mkYesod is a Template Haskell function, and parseRoutes is a QuasiQuoter.
mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET |]

instance Yesod HelloWorld

getHomeR :: Handler Html
getHomeR = defaultLayout [whamlet|HelloWorld Coneee!|]

main :: IO ()
main = warp 3000 HelloWorld