{-# LANGUAGE TypeFamilies, TypeInType, TypeOperators, TypeApplications #-}
{-# LANGUAGE GADTs, RankNTypes, ScopedTypeVariables #-}
{-# LANGUAGE ConstraintKinds, AllowAmbiguousTypes #-}

module ThoralfPlugin.Singletons.Nat (SNat(..), NatComp(..), natComp) where

import Data.Kind (Constraint, Type)
import GHC.TypeLits (Nat, KnownNat, natVal)
import Unsafe.Coerce (unsafeCoerce)

import Data.Theory.Bool (type (<?))

data SNat :: Nat -> Type where
    SNat :: KnownNat n => SNat n

data NatComp :: Nat -> Nat -> Type where
    NEq :: n ~ m => NatComp n m
    NLt :: n <? m ~ 'True => NatComp n m
    NGt :: m <? n ~ 'True => NatComp n m

natComp :: forall n m. SNat n -> SNat m -> NatComp n m
natComp n@SNat m@SNat = case compare (natVal n) (natVal m) of
    EQ -> forceCT @(n ~ m) NEq
    LT -> forceCT @(n <? m ~ 'True) NLt
    GT -> forceCT @(m <? n ~ 'True) NGt

-- | Force constraints.
forceCT :: forall c x. (c => x) -> x
forceCT x = case unsafeCoerce (Dict :: Dict ()) :: Dict c of
    (Dict :: Dict c) -> x

data Dict :: Constraint -> Type where
    Dict :: a => Dict a
