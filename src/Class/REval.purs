module Data.Struct.REval
  ( class REval
  , reval
  ) where

import Control.Subcategory.Constituency (class ObjectOf)
import Control.Subcategory.Slackable (class Slackable, slacken)
import Type.Proxying (class RLProxying)
import Type.Row (kind RowList)

class REval
  (p  :: Type -> Type -> Type)
  (f  :: # Type -> Type)
  (l0 :: RowList)
  (r0 :: # Type)
  (l1 :: RowList)
  (r1 :: # Type)
  | l0 -> r0
  , l1 -> r1
  where
  reval
    :: forall g
     . RLProxying g l0
    => RLProxying g l1
    => g l0
    -> g l1
    -> p (f r0) (f r1)
    -> f r0
    -> f r1

instance revalSlackable
  :: ( ObjectOf p (f r0)
     , ObjectOf p (f r1)
     , Slackable p
     )
  => REval p f l0 r0 l1 r1 where
  reval _ _ = slacken
