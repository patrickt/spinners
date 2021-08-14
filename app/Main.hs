{-# LANGUAGE BlockArguments #-}
module Main (main) where

import System.Console.Spinner
import Control.Monad


main :: IO ()
main = do
  spin <- pipe
  withHiddenCursor (forever (draw spin))
