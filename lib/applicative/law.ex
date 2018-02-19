defmodule Applicative.Law do
  @moduledoc false

  import Curry
  use Monad.Operators

  # http://hackage.haskell.org/package/base-4.7.0.2/docs/Control-Applicative.html
  # http://staff.city.ac.uk/~ross/papers/Applicative.pdf

  # pure id <*> v = v
  def identity?(applicative, pure_fun) do
    pure_fun.(& &1) <~> applicative == applicative
  end

  # pure (.) <*> u <*> v <*> w = u <*> (v <*> w)
  def composition?(fun1, fun2, fun3, value, pure_fun) do
    lhs = pure_fun.(curry(& &1.(&2.(&3.(&4))))) <~> fun1 <~> fun2 <~> fun3 <~> value
    rhs = fun1 <~> (fun2 <~> (fun3 <~> value))
    lhs == rhs
  end

  # pure f <*> pure x = pure (f x)
  def homomorphism?(fun, value, pure_fun) do
    pure_fun.(fun) <~> pure_fun.(value) == pure_fun.(fun.(value))
  end

  # u <*> pure y = pure ($ y) <*> u
  def interchange?(applicative_fun, value, pure_fun) do
    applicative_fun <~> pure_fun.(value) == pure_fun.(& &1.(value)) <~> applicative_fun
  end
end
