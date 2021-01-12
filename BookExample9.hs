-- primer internacionalizacije u yesodu, put poruke od tipa do render funkcije, do templejta i na kraju do Html-a.
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE OverloadedStrings #-}
import Data.Text (Text)
import qualified Data.Text as T
import Text.Hamlet (HtmlUrlI18n, ihamlet)
import Text.Blaze.Html (toHtml)
import Text.Blaze.Html.Renderer.String (renderHtml)

data MYRoute = Home | Time | Stylesheet

renderUrl :: MYRoute -> [(Text, Text)] -> Text
renderUrl Home _ = "/home"
renderUrl Time _ = "/time"
renderUrl Stylesheet _ = "/style.css"

data Msg = Hello | Apples Int

renderEng :: Msg -> Text
renderEng Hello = "Hello"
renderEng (Apples 0) = "You did not bought any apples."
renderEng (Apples 1) = "You bought 1 apple."
renderEng (Apples i) = T.concat ["You bought ", T.pack $ show i, " apples."]

template :: Int -> HtmlUrlI18n Msg MYRoute
template count = [ihamlet|
$doctype 5
<html>
    <head>
        <tittle>i18n
    <body>
        <h1>_{Hello}
        <p>_{Apples count}
|]

main :: IO()
main = putStrLn $ renderHtml $ (template 5) (toHtml . renderEng) renderUrl