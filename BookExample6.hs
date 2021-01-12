{-# LANGUAGE QuasiQuotes #-}
import Text.Lucius
import qualified Data.Text.Lazy.IO as TLIO

-- nebitna render funkcija
render = undefined

-- nas miks css stavki
transition val = [luciusMixin|
    -webkit-transition: #{val};
    -moz-transition: #{val};
    -ms-transition: #{val};
    -o-transition: #{val};
    transition: #{val};
|]

-- nas CSS koji koristi miks i prosledjuje mu vrednost
myCss = [lucius|
    .some-class {
        ^{transition "all 4s ease"}
    }
|]

main = TLIO.putStrLn $ renderCss $ myCss render