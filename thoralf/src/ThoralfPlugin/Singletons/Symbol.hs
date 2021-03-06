{-# LANGUAGE TypeFamilies, TypeInType, TypeOperators, TypeApplications #-}
{-# LANGUAGE GADTs, RankNTypes, ScopedTypeVariables #-}
{-# LANGUAGE ConstraintKinds, AllowAmbiguousTypes #-}

module ThoralfPlugin.Singletons.Symbol (SSymbol(..), scomp) where

import Data.Kind (Constraint, Type)
import GHC.TypeLits (symbolVal, Symbol, KnownSymbol)
import Unsafe.Coerce (unsafeCoerce)

import Data.Theory.DisEq (DisEquality, (:~?~:)(..))

data SSymbol :: Symbol -> Type where
    SSym :: KnownSymbol s => SSymbol s

scomp :: SSymbol s -> SSymbol s' -> s :~?~: s'
scomp s@(SSym :: SSymbol s) s'@(SSym :: SSymbol s') =
    if symbolVal s == symbolVal s'
       then unsafeCoerce Refl
       else forceCT @(DisEquality s s') DisRefl

-- | Force constraints.
forceCT :: forall c x. (c => x) -> x
forceCT x = case unsafeCoerce (Dict :: Dict ()) :: Dict c of
    (Dict :: Dict c) -> x

data Dict :: Constraint -> Type where
    Dict :: a => Dict a
