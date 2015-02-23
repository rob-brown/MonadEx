defmodule Monad.Law do
  use Monad.Operators

  # The three monad laws, see:
  # https://www.haskell.org/haskellwiki/Monad_laws
  # https://en.wikipedia.org/wiki/Monad_(functional_programming)#Monad_laws
  # http://codeplease.io/monads/

  # In Haskell:
  # (return x) >>= f ≡ f x
  def left_identity?(value, construct_fun, fun) do
    (construct_fun.(value) ~>> fun) == fun.(value)
  end

  # In Haskell:
  # m >>= return ≡ m
  def right_identity?(monad, construct_fun) do
    (monad ~>> construct_fun) == monad
  end

  # In Haskell:
  # (m >>= f) >>= g ≡ m >>= ( \x -> (f x >>= g) )
  def associativity?(monad, fun1, fun2) do
    (monad ~>> fun1 ~>> fun2) == (monad ~>> &(fun1.(&1) ~>> fun2))
  end
end
