{-# LANGUAGE TypeFamilies, TypeInType, TypeOperators #-}
{-# LANGUAGE UndecidableInstances, RankNTypes, ConstraintKinds, GADTs #-}

-- | This module declares the finite maps interface.
module Data.Theory.FiniteMap
  ( Fm
  , Nil
  , Has
  , Omits
  , FromList
  , AddField
  , DelField
  , UnionFm
  , IntersectFm
  ) where

import Data.Kind (Type)

-- The sole data definition, everything else is the exposed grammar.
data Fm :: forall k v. k -> v -> Type where {}

-- The Encoding
type family Nil :: Fm (k :: Type) (v :: Type) where {}
type family Alter (m :: Fm k v) (key :: k) (val :: v) :: Fm k v where {}
type family Delete (m :: Fm (k :: Type) (v :: Type)) (key :: k) :: Fm k v where {}
type family UnionL (m :: Fm (k :: Type) (v :: Type)) (m' :: Fm k v) :: Fm k v where {}
type family IntersectL (m :: Fm (k :: Type) (v :: Type)) (m' :: Fm k v) :: Fm k v where {}

-- Contraints
type Has m k v = Alter m k v ~ m
type Omits m k = Delete m k ~ m
type AddField m m' k v = Alter m k v ~ m'
type DelField m m' k = Delete m k ~ m'
type UnionFm m1 m2 u = u ~ UnionL m1 m2
type IntersectFm m1 m2 i = i ~ IntersectL m1 m2

type family FromList (xs :: [(k,v)]) :: Fm k v where
    FromList '[] = Nil
    FromList ( '(k,v) : ys ) = (Alter (FromList ys) k v)
