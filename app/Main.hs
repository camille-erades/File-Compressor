{- 
-- EPITECH PROJECT, 2023
-- PGD
-- File description:
-- Main.hs
-}

import System.IO
import Text.Read (readMaybe)
import Data.Char (isDigit)
import System.Environment (getArgs)
import System.Exit (exitFailure)
import System.Random (randomRIO)
import KMeans
import Types

rngColors :: IO Color
rngColors = do
  r <- randomRIO (0, 255)
  g <- randomRIO (0, 255)
  b <- randomRIO (0, 255)
  return (r, g, b)

rngCentroids :: Int -> IO [Color]
rngCentroids n = sequence [rngColors | _ <- [1..n]]

isNumberChar :: Char -> Bool
isNumberChar c = isDigit c || c == '-'

getNumber :: String -> (Int, String)
getNumber str = (read numStr, rest)
    where (numStr, rest) = span isNumberChar str

getFiveIntegers :: String -> [Int]
getFiveIntegers str = go 5 str []
    where
        go 0 _ acc = reverse acc
        go n s acc
            | null numStr = go n (dropWhile (not . isNumberChar) rest) acc
            | otherwise   = go (n-1) rest (num : acc)
            where
                (num, rest) = getNumber s
                numStr = takeWhile isNumberChar s

splitList :: [Int] -> ([Int], [Int])
splitList ints =
    if length ints /= 5
        then error "file have some invalid pixels"
        else splitAt 2 ints

createPixelMap :: String -> [Pixel]
createPixelMap line =
    case splitList val of
        (firstTwo, rest) ->
            [((firstTwo !! 0, firstTwo !! 1),
            (rest !! 0, rest !! 1, rest !! 2))]
    where
        val = getFiveIntegers line

printCluster :: Cluster -> IO ()
printCluster (Cluster centroid pixels) =
    putStrLn "--" >>
    putStrLn (show centroid) >>
    putStrLn "-" >>
    mapM_ (\((x, y), color) ->
        putStrLn $ show (x, y) ++ " " ++ show color) pixels

processContents :: Int -> Float -> String -> [Color] -> IO ()
processContents n l contents centroids =
    let linesOfFile = lines contents
        pixelMap = concatMap createPixelMap linesOfFile
        clusters = kMeans n l centroids pixelMap
    in mapM_ printCluster clusters

processFile :: Int -> Float -> FilePath -> IO ()
processFile n l file = do
    handle <- openFile file ReadMode
    contents <- hGetContents handle
    randomCentroids <- rngCentroids n
    processContents n l contents randomCentroids
    hClose handle

main :: IO ()
main = do
    args <- getArgs
    case args of
        ["-n", nStr, "-l", lStr, "-f", file] ->
            case (readMaybe nStr, readMaybe lStr) of
                (Just n, Just l) -> processFile n l file
                _ -> putStrLn "Invalid number or limit" >> exitFailure
        _ -> putStrLn "Usage: ./imageCompressor -n N -l L -f F" >> exitFailure
