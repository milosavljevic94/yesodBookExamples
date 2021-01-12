-- primer za pozivanje izgleda uz pomoc quasi quotera
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes#-}
import Text.Hamlet (HtmlUrl, hamlet)
import Data.Text (Text)
import Text.Blaze.Html.Renderer.String (renderHtml)

data MyRoute = Home | Time | Stylesheat

render :: MyRoute -> [(Text, Text)] -> Text
render Home _ = "/home"
render Time _ = "/time"
render Stylesheat _ = "/style.css"

template :: Text -> HtmlUrl MyRoute
template tittle = [hamlet|
$doctype 5
<html>
    <head>
        <tittle>#{tittle}
        <link rel=stylesheet href=@{Stylesheat}>
    <body>
        <h1>#{tittle}
|]

main :: IO()
main = putStrLn $ renderHtml $ template "Neki naslov" render