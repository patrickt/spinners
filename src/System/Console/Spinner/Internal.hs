{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE NamedFieldPuns #-}

module System.Console.Spinner.Internal
  ( module System.Console.Spinner.Internal
  )
where

import Control.Exception (bracket_)
import Control.Monad
import Data.IORef
import Data.Time.Clock
import System.Console.ANSI qualified as ANSI
import System.Console.ANSI.Types

data Spinner = Spinner
  { interval :: NominalDiffTime,
    contents :: IORef String,
    lastRendered :: IORef UTCTime
  }

create :: String -> NominalDiffTime -> IO Spinner
create c i = do
  now <- getCurrentTime
  Spinner i <$> newIORef (cycle c) <*> newIORef now

draw :: Spinner -> IO ()
draw Spinner {interval, contents, lastRendered} = do
  let start = ANSI.setSGR [SetColor Foreground Dull Yellow]
  let end = ANSI.setSGR [Reset]

  bracket_ start end do
    ANSI.setCursorColumn 0
    putChar ' '
    tile <- head <$> readIORef contents
    putChar tile
    putChar ' '

    now <- getCurrentTime
    past <- readIORef lastRendered
    let diff = diffUTCTime now past
    when (interval < diff) do
      writeIORef lastRendered now
      modifyIORef' contents tail

erase :: Spinner -> IO ()
erase Spinner {lastRendered} = do
  getCurrentTime >>= writeIORef lastRendered
  ANSI.clearFromCursorToLineBeginning

withHiddenCursor :: IO a -> IO a
withHiddenCursor = bracket_ ANSI.hideCursor ANSI.showCursor
