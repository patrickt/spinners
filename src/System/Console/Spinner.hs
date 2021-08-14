{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE NamedFieldPuns #-}

-- |
--
-- This module is designed to be imported qualified:
--
-- >  import System.Console.Spinner qualified as Spinner
module System.Console.Spinner
  ( -- * Basic types
    Spinner,
    create,
    draw,
    erase,

    -- * Helpers
    withHiddenCursor,

    -- * Predefined spinners
    pipe,
    dots1,
  )
where

import System.Console.Spinner.Internal

dots1 :: IO Spinner
dots1 = create "⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏" 0.25

pipe :: IO Spinner
pipe = create "┤┘┴└├┌┬┐" 0.25
