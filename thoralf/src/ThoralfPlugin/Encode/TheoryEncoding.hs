{-# LANGUAGE GADTs #-}
{-# OPTIONS_HADDOCK ignore-exports #-}
{-# OPTIONS_HADDOCK show-extensions #-}

module ThoralfPlugin.Encode.TheoryEncoding
    (
    -- * Encoding
    -- $theoryEncoding
    TheoryEncoding (..)
    , emptyTheory
    -- * Continuations
    -- ** Type
    , TyConvCont (..)
    -- ** Kind
    , KdConvCont (..)
    -- ** Declaration
    -- $decCont
    , DecCont (..)
    , sumEncodings
    , Vec (..)
    , Nat (..)
    ) where

import Control.Applicative ((<|>))
import Data.Vec (Vec(..), Nat(..))
import GHC.Corroborate

-- | Predicated on type variables 'tyVarPreds' take the encoding of a type
-- variable, and create SMT statements which can be asserted that restrict the
-- variable in question. This is useful for restricting the domain of
-- a converted type. For instance, if type level naturals are converted into
-- SMT integers, asserting each integer variable is larger than zero is
-- sensible.
data TheoryEncoding where
    TheoryEncoding
        ::
            { kindConvs :: [Type -> Maybe KdConvCont]
            , typeConvs :: [Type -> Maybe TyConvCont]
            , startDecs :: [String] -- ^ Top level, never changing declarations
            , tyVarPreds :: TyVar -> Maybe [String]
            }
        -> TheoryEncoding

-- $theoryEncoding
--
-- To encode a theory into SMT, we essentially need to provide functions that
-- can take a GHC type (that is not a type variable) and turn it into a SMT
-- expression. To blend theories, this is done with continuations. Each
-- conversion function only converts part of a type, and provides a pair of
-- subterms and a function to use the converted subterms.
--
-- Encoding a theory also requires converting GHC variables to SMT variables.
-- This needs conversion functions that convert the GHC Kind of a variable into
-- a valid SMT sort, again using continuations. Lastly, some type conversions
-- require SMT functions over generic SMT data types. Since SMT doesn't support
-- polymorhphic functions, these functions need to be unique per the kind of
-- their arguments. These are continuations in 'DecCont'.

-- | A Kind Conversion Continuation
data KdConvCont where
    KdConvCont
        ::
            { kdConvKinds :: Vec m Kind
            , kdConvCont :: Vec m String -> String
            }
        -> KdConvCont

-- | A Type Conversion Continuation
data TyConvCont where
    TyConvCont
        ::
            { tyConvTypes :: Vec n Type
            , tyConvKinds :: Vec m Kind
            , tyConvCont :: Vec n String -> Vec m String -> String
            , tyConvDecs :: [DecCont]
            }
        -> TyConvCont

-- | The 'decCont' are declaration continuations. These are data types for
-- building local SMT declarations. SMT declarations are simply a list of
-- strings that are valid SMT commands, after which some function symbol
-- becomes meaningful and can be used when converting a type. These
-- declarations are local because the definition of these function symbols
-- depend on the sorts of their inputs. These sorts are determined by
-- converting the kinds into a list of strings and feeding that to the
-- 'decCont' function.  A 'DecCont' must satisfy the property that two
-- declarations are the same if and only if the converted list of kinds and the
-- hashes are the same.  So, to make each declaration different, an encoding
-- must use a hash of the converted list of kinds along with the given hash to
-- ensure no declarations are repeated.
data DecCont where
    DecCont
        ::
            { decContKds :: Vec n Kind
            , decContHash :: String
            , decCont :: Vec n String -> [String]
            }
        -> DecCont

-- | Combining monadic theory encodings.
sumEncodings :: [TcPluginM TheoryEncoding] -> TcPluginM TheoryEncoding
sumEncodings = fmap (foldl addEncodings emptyTheory) . sequence

-- | An empty theory from which you can build any theory.
emptyTheory :: TheoryEncoding
emptyTheory =
    TheoryEncoding
        { typeConvs = []
        , kindConvs = []
        , startDecs = []
        , tyVarPreds = const Nothing
        }

addEncodings :: TheoryEncoding -> TheoryEncoding -> TheoryEncoding
addEncodings
    TheoryEncoding{typeConvs = t1, kindConvs = k1, startDecs = s1, tyVarPreds = p1}
    TheoryEncoding{typeConvs = t2, kindConvs = k2, startDecs = s2, tyVarPreds = p2} =
    TheoryEncoding{typeConvs = t', kindConvs = k', startDecs = s', tyVarPreds = p'}
    where
        t' = t1 ++ t2
        k' = k1 ++ k2
        s' = s1 ++ s2
        p' tvar = p1 tvar <|> p2 tvar
