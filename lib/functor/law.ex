defmodule Functor.Law do
  use Monad.Operators

  # fmap id ≡ id
  def identity?(functor, id_fun) do
    (id_fun <|> functor) == functor
  end

  # fmap (f . g) ≡ fmap f . fmap g
  def composition?(functor, fun1, fun2) do
    (&(fun1.(fun2.(&1))) <|> functor) == (fun1 <|> (fun2 <|> functor))
  end
end
