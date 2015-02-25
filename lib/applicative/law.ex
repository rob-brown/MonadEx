defmodule Applicative.Law do
  @moduledoc false
  

  # TODO:
  # pure f <*> x = fmap f x
  # pure id <*> v = v
  # pure (.) <*> u <*> v <*> w = u <*> (v <*> w)
  # pure f <*> pure x = pure (f x)
  # u <*> pure y = pure ($ y) <*> u

end
