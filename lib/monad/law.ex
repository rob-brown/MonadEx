defmodule Monad.Law do
  @moduledoc false

  use Monad.Operators

  # The three monad laws, see:
  # https://www.haskell.org/haskellwiki/Monad_laws
  # https://en.wikipedia.org/wiki/Monad_(functional_programming)#Monad_laws
  # http://codeplease.io/monads/

  # In Haskell:
  # (return x) >>= f ≡ f x
  @doc false
  def left_identity?(value, return_fun, fun) do
    (return_fun.(value) ~>> fun) == fun.(value)
  end

  # In Haskell:
  # m >>= return ≡ m
  @doc false
  def right_identity?(monad, return_fun) do
    (monad ~>> return_fun) == monad
  end

  # In Haskell:
  # (m >>= f) >>= g ≡ m >>= ( \x -> (f x >>= g) )
  @doc false
  def associativity?(monad, fun1, fun2) do
    (monad ~>> fun1 ~>> fun2) == (monad ~>> &(fun1.(&1) ~>> fun2))
  end
end
