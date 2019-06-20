module Data.Struct.RGetOrAlt
  ( class RGetOrAlt
  , rgetOrAlt
  ) where

import Prelude (pure, (<<<))

import Control.Alternative (class Alternative)
import Data.Symbol (class IsSymbol, SProxy(SProxy))
import Data.Variant (Variant)
import Data.Variant (prj) as Variant
import Record (get) as Record
import Type.Proxying (class RLProxying, class SProxying)
import Type.Row (class Cons, kind RowList)

class RGetOrAlt
  (f  :: # Type -> Type)
  (g  :: Symbol -> Type)
  (s  :: Symbol)
  (l :: RowList)
  (r :: # Type)
  | l -> r
  where
  rgetOrAlt
    :: forall h i r' v
     . Alternative h
    => Cons s v r' r
    => RLProxying i l
    => i l
    -> g s
    -> f r
    -> h v

instance rgetOrAltRecord
  :: ( IsSymbol s
     , SProxying g s
     )
  => RGetOrAlt Record g s l r
  where
  rgetOrAlt _ _ = pure <<< Record.get (SProxy :: SProxy s)

instance rgetOrAltVariant
  :: ( IsSymbol s
     , SProxying g s
     )
  => RGetOrAlt Variant g s l r
  where
  rgetOrAlt _ _ = Variant.prj (SProxy :: SProxy s)
