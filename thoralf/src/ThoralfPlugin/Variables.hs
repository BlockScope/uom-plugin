module ThoralfPlugin.Variables where

import GHC.Corroborate

data VarCat = Tau | Skol | Irr deriving Eq

categorizeVar :: Var -> VarCat
categorizeVar var =
    if isTcTyVar var
        then
            if isMetaTyVar var then Tau else Skol
        else
            Irr

isSkolemVar :: Var -> Bool
isSkolemVar v = categorizeVar v == Skol

isTauVar :: TyVar -> Bool
isTauVar v = categorizeVar v == Tau
