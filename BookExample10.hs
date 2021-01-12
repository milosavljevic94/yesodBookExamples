{-# LANGUAGE QuasiQuotes, OverloadedStrings #-}
import Text.Shakespeare.Text
import qualified Data.Text.Lazy.IO as TLIO
import Data.Text (Text)
import Control.Monad (forM_)

data Item = Item {
    itemName :: Text,
    itemQty :: Int
}

items :: [Item]
items = [
        Item "Apples" 3,
        Item "Bannanas" 7
        ]

main :: IO()                                    -- quai quoter lt, znaci lazy text. Pored njega postoji i st(standard text).
main = forM_ items $ \item -> TLIO.putStrLn[lt|
You have #{show $ itemQty item} #{itemName item}.|]