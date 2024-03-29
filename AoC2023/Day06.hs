module Day06 where

import HB.Ch09 (splitAndDrop)
import System.IO

-- Puz 1 -----------------------------------------------------------------------

testInput =
  [ "Time:      7  15   30",
    "Distance:  9  40  200"
  ]

testOutput = 288

data Race = Race {raceTime :: Int, raceDistance :: Int} deriving (Eq, Show)

parseRaces :: [String] -> [Race]
parseRaces ss = map (\(t, d) -> Race {raceTime = t, raceDistance = d}) $ zip times dists
  where
    timeStr = head ss
    distStr = head $ drop 1 ss
    times = map (read) $ words $ last $ splitAndDrop ':' timeStr :: [Int]
    dists = map (read) $ words $ last $ splitAndDrop ':' distStr :: [Int]

finalDistance :: Race -> Int -> Int
finalDistance r tHold = tHold * (raceTime r - tHold)

minimumHold :: Race -> Int
minimumHold r = head $ dropWhile (\th -> finalDistance r th < raceDistance r + 1) [0 .. raceTime r]

minimumHold' :: Race -> Int
minimumHold' (Race tf dfm1) = round $ fromIntegral (-tf + floor (sqrt disc)) / (-2)
  where
    df = dfm1 + 1
    disc = fromIntegral $ tf ^ 2 - 4 * df

maximumHold :: Race -> Int
maximumHold r = head $ dropWhile (\th -> finalDistance r th < raceDistance r + 1) $ reverse [0 .. raceTime r]

maximumHold' :: Race -> Int
maximumHold' (Race tf dfm1) = round $ fromIntegral (-tf - floor (sqrt disc)) / (-2)
  where
    df = dfm1 + 1
    disc = fromIntegral $ tf ^ 2 - 4 * df

numStrats :: Race -> Int
numStrats r = maximumHold r - minimumHold r + 1

numStrats' :: Race -> Int
numStrats' r = maximumHold' r - minimumHold' r + 1

sol :: [String] -> Int
sol = (foldr (*) 1) . (map numStrats) . parseRaces

-- Puz 2 -----------------------------------------------------------------------

test2Output = 71503

parseRace :: [String] -> Race
parseRace ss = Race t d
  where
    timeStr = head ss
    distStr = head $ drop 1 ss
    t = (read . concat . words . last) $ splitAndDrop ':' timeStr :: Int
    d = (read . concat . words . last) $ splitAndDrop ':' distStr :: Int

-- Not the fastest thing ever, but the quadratic formulation (numStrats') gave me a wrong number on the test input...
sol2 :: [String] -> Int
sol2 = numStrats' . parseRace

-- IO --------------------------------------------------------------------------

cli :: IO ()
cli = do
  putStrLn "Welcome to Day 06!"
  putStrLn "Which puzzle would you like to solve (1):"
  puzNum <- getLine
  fHandle <- openFile "AoC2023/input/Day06.txt" ReadMode
  raw <- hGetContents fHandle
  case (read puzNum) :: Int of
    1 -> print $ sol $ lines raw
    2 -> print $ sol2 $ lines raw
    _ -> print "Invalid puzzle"
