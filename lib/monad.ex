defprotocol Monad do
  @fallback_to_any true

  # Functors need a `flat_map` function.
  # Takes a function and a functor and returns a functor.
  # fmap :: (a -> b) -> f a -> f b
  # ((a -> b), f a) -> f b
  def flat_map(value, fun)

  # Applicatives need an `apply` function.
  # Takes an applicative function and an applicative value and returns an applicative.
  # (a (b -> c), a b) -> a c
  def apply(value, fun)

  # Monads need a `bind` function.
  # Takes a monad value and a function that returns a monad and returns a monad.
  # (>>=) :: m a -> (a -> m b) -> m b
  # (m a, (a -> m b)) -> m b
  def bind(value, fun)
end

# TODO: Make reader, writer, and state monads. http://adit.io/posts/2013-06-10-three-useful-monads.html

defimpl Monad, for: Any do

  def bind(nil, fun) when is_function(fun, 1), do: nil
  def bind(value, fun) when is_function(fun, 1) do
    fun.(value)
  end

  def flat_map(nil, fun) when is_function(fun, 1), do: nil
  def flat_map(value, fun) when is_function(fun, 1) do
    fun.(value)
  end

  def apply(value, fun) do
    bind(fun, &(flat_map value, &1))
  end
end

defmodule Monad.Operators do

  defmacro lhs ~>> rhs do
    quote bind_quoted: [lhs: lhs, rhs: rhs] do
      Monad.bind lhs, rhs
    end
  end

  defmacro lhs <|> rhs do
    quote bind_quoted: [lhs: lhs, rhs: rhs] do
      Monad.flat_map rhs, lhs
    end
  end

  defmacro lhs <~> rhs do
    quote bind_quoted: [lhs: lhs, rhs: rhs] do
      Monad.apply rhs, lhs
    end
  end

  defmacro __using__(_) do
    quote do
      import Kernel, except: [<|>: 2, <~>: 2, ~>>: 2]
      import Monad.Operators
    end
  end
end
