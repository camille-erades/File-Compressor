{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_ImgCompress (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath



bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/home/cerades/delivery/tech2/sem1/B-FUN-400-LYN-4-1-compressor-malo.coet/.stack-work/install/x86_64-linux-tinfo6/ff10afc7dfdcf4b0d7cd93d57bf9e4bf7d7a0ea098582b1039c32e0bbeee51ca/9.2.5/bin"
libdir     = "/home/cerades/delivery/tech2/sem1/B-FUN-400-LYN-4-1-compressor-malo.coet/.stack-work/install/x86_64-linux-tinfo6/ff10afc7dfdcf4b0d7cd93d57bf9e4bf7d7a0ea098582b1039c32e0bbeee51ca/9.2.5/lib/x86_64-linux-ghc-9.2.5/ImgCompress-0.1.0.0-JKaCkoTI2XUKQRKEf2zICO"
dynlibdir  = "/home/cerades/delivery/tech2/sem1/B-FUN-400-LYN-4-1-compressor-malo.coet/.stack-work/install/x86_64-linux-tinfo6/ff10afc7dfdcf4b0d7cd93d57bf9e4bf7d7a0ea098582b1039c32e0bbeee51ca/9.2.5/lib/x86_64-linux-ghc-9.2.5"
datadir    = "/home/cerades/delivery/tech2/sem1/B-FUN-400-LYN-4-1-compressor-malo.coet/.stack-work/install/x86_64-linux-tinfo6/ff10afc7dfdcf4b0d7cd93d57bf9e4bf7d7a0ea098582b1039c32e0bbeee51ca/9.2.5/share/x86_64-linux-ghc-9.2.5/ImgCompress-0.1.0.0"
libexecdir = "/home/cerades/delivery/tech2/sem1/B-FUN-400-LYN-4-1-compressor-malo.coet/.stack-work/install/x86_64-linux-tinfo6/ff10afc7dfdcf4b0d7cd93d57bf9e4bf7d7a0ea098582b1039c32e0bbeee51ca/9.2.5/libexec/x86_64-linux-ghc-9.2.5/ImgCompress-0.1.0.0"
sysconfdir = "/home/cerades/delivery/tech2/sem1/B-FUN-400-LYN-4-1-compressor-malo.coet/.stack-work/install/x86_64-linux-tinfo6/ff10afc7dfdcf4b0d7cd93d57bf9e4bf7d7a0ea098582b1039c32e0bbeee51ca/9.2.5/etc"

getBinDir     = catchIO (getEnv "ImgCompress_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "ImgCompress_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "ImgCompress_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "ImgCompress_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "ImgCompress_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "ImgCompress_sysconfdir") (\_ -> return sysconfdir)




joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
