{- 
-- EPITECH PROJECT, 2023
-- PGD
-- File description:
-- KMeans.hs
-}

module KMeans (
    euclidDistance,
    closestCentroidIndex,
    linkToClusters,
    groupByCentroidIndex,
    checkCentroid,
    checkConverge,
    kMeans
) where

import Types (Point, Color, Pixel, Cluster(..))
import qualified Data.Map.Strict as Map

--Distance entre deux couleurs.
euclidDistance :: Color -> Color -> Float
euclidDistance (r1, g1, b1) (r2, g2, b2) =
    sqrt $ fromIntegral ((r1 - r2) ^ 2 + (g1 - g2) ^ 2 + (b1 - b2) ^ 2)

--Idex du centroïde le plus proche pour un pixel.
closestCentroidIndex :: [Color] -> Color -> Int
closestCentroidIndex centroids color =
    snd . minimum $ zip (map (euclidDistance color) centroids) [0..]

--Attribue chaque pixel au centroïde le plus proche + clustering.
linkToClusters :: [Color] -> [Pixel] -> [Cluster]
linkToClusters centroids pixels =
    let
        pixelCentroidDuo = map (\(p, c) ->
            (closestCentroidIndex centroids c, (p, c))) pixels      --Association pixel -> centroide le plus proche.
        clustersMap = groupByCentroidIndex pixelCentroidDuo         --Groupe les pixels par index du centroïde.
    in
        map (\(idx, ps) ->
            Cluster (centroids !! idx) ps) (Map.toList clustersMap) --Convertit la map des clusters en list de cluster.

--Groupe les pixels par l'index de leur centroïde dans une map.
groupByCentroidIndex :: [(Int, Pixel)] -> Map.Map Int [Pixel]
groupByCentroidIndex duo = foldr insertInMap Map.empty duo
  where
    insertInMap (idx, pixel) = Map.alter (appendPixel pixel) idx
    appendPixel pixel Nothing = Just [pixel]
    appendPixel pixel (Just pixels) = Just (pixel:pixels)

--Recalcul le centroïde d'un cluster donné (la couleur moyenne de tous les pixels dans le cluster).
checkCentroid :: [Pixel] -> Color
checkCentroid pixels =
  let
    sumFunc = \(r, g, b) (accR, accG, accB, accCount) ->
      (accR + r, accG + g, accB + b, accCount + 1)
    (sumR, sumG, sumB, count) =
      foldr sumFunc (0, 0, 0, 0) (map snd pixels)
    mean val count = val `div` count
  in
    (mean sumR count, mean sumG count, mean sumB count)


--Détermine si le centroid a convergé.
checkConverge :: Float -> Color -> Color -> Bool
checkConverge trshHold c1 c2 = euclidDistance c1 c2 < trshHold

--Exécute l'algorithme k-means jusqu'à ce que les centroïdes convergent.
kMeans :: Int -> Float -> [Color] -> [Pixel] -> [Cluster]
kMeans k trshHold initialCentroids pixels = go initialCentroids
  where
    go :: [Color] -> [Cluster]
    go centroids = 
        let clusters = linkToClusters centroids pixels
            newCentroids = map (\(Cluster _ pxs) -> checkCentroid pxs) clusters
        in if all (\(old, new) -> checkConverge trshHold old new) 
                  (zip centroids newCentroids)
           then clusters
           else go newCentroids
