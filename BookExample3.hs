-- Just ignore the quasiquote stuff for now, and that shamlet thing.
-- It will be explained later.
{-# LANGUAGE QuasiQuotes #-}

import Text.Hamlet (shamlet)
import Text.Blaze.Html.Renderer.String (renderHtml)
import Data.Char (toLower)
import Data.List (sort)

data Person = Person
    {
        name :: String,
        age :: Int
    }

main :: IO ()
main = putStrLn $ renderHtml [shamlet|
<p>Hello my name is #{name person}, and I am #{show $ age person}.
<p>
    Some funny stuff with name : #
    <b>#{sort $ map toLower(name person)}
<p>And in a 5 years I will be #{show ((+) 5 (age person))} years old.
|]
    where
        person = Person "Nemanja" 26