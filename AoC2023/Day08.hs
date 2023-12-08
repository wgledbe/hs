module Day08 where

import Data.List (find)
import HB.Ch09 (splitAndDrop)
import HB.Ch11 (BinaryTree (Leaf, Node), contains)
import System.IO

-- Puz 1 -----------------------------------------------------------------------

testInput1 =
  [ "RL",
    "",
    "AAA = (BBB, CCC)",
    "BBB = (DDD, EEE)",
    "CCC = (ZZZ, GGG)",
    "DDD = (DDD, DDD)",
    "EEE = (EEE, EEE)",
    "GGG = (GGG, GGG)",
    "ZZZ = (ZZZ, ZZZ)"
  ]

testOutput1 = 2

testInput2 =
  [ "LLR",
    "",
    "AAA = (BBB, BBB)",
    "BBB = (AAA, ZZZ)",
    "ZZZ = (ZZZ, ZZZ)"
  ]

testOutput2 = 6

unfoldTree :: String -> [(String, (String, String))] -> BinaryTree String
unfoldTree start branches = case generate start of
  Just (left, center, right) -> Node (unfoldTree left branches) center (unfoldTree right branches)
  Nothing -> Node Leaf start Leaf
  where
    generate x = case find (\(n, (l, r)) -> n == x) branches of
      Just (node, (l, r)) -> Just (l, node, r)
      Nothing -> Nothing

listifyWithSteps :: String -> BinaryTree String -> [String]
listifyWithSteps steps tree = go (concat $ repeat steps) tree
  where
    go _ Leaf = []
    go (s : ss) (Node lt c rt) = case s of
      'L' -> c : go ss lt
      'R' -> c : go ss rt
      _ -> error $ "Incorrect direction indicator: " ++ [s]

pathTo :: String -> String -> BinaryTree String -> [String]
pathTo end steps tree = takeWhile (/= end) $ listifyWithSteps steps tree

parseBranch :: String -> (String, (String, String))
parseBranch bs = (node, (l, r))
  where
    nodeLR = splitAndDrop '=' bs
    node = takeWhile (/= ' ') $ head nodeLR
    lrStr = drop 1 $ last nodeLR
    l = take 3 $ drop 1 lrStr
    r = take 3 $ drop 6 lrStr

parseInput :: [String] -> (String, [(String, (String, String))])
parseInput ls = (dirs, map parseBranch branchStrs)
  where
    dirs = head ls
    branchStrs = drop 2 ls

sol :: [String] -> Int
sol ls = length $ pathTo "ZZZ" steps tree
  where
    (steps, branches) = parseInput ls
    tree = unfoldTree "AAA" branches

-- IO --------------------------------------------------------------------------

cli :: IO ()
cli = do
  putStrLn "Welcome to Day 08!"
  putStrLn "Which puzzle would you like to solve (1)?"
  puzNum <- getLine
  fHandle <- openFile "AoC2023/input/Day08.txt" ReadMode
  raw <- hGetContents fHandle
  case (read puzNum) :: Int of
    1 -> (print . sol . lines) raw
    _ -> print "Invalid puzzle"
