{- 
-- EPITECH PROJECT, 2023
-- PGD
-- File description:
-- Types.hs
-}

module Types (
    Point, Color, Pixel, Cluster(..)
) where

type Point = (Int, Int)

type Color = (Int, Int, Int)

type Pixel = (Point, Color)

data Cluster = Cluster {
    centroid :: Color,
    pixels :: [Pixel]
} deriving (Show)