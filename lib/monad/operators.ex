defmodule Monad.Operators do
  @moduledoc """
  Convenient, but optional, operators for working with `Functor`s,
  `Applicative`s, and `Monad`s.

  To use these operators, simply call `use Monad.Operators`.
  """

  @doc """
  The bind operator.

  See `Monad.bind/2` for more details.
  """
  defmacro lhs ~>> rhs do
    quote bind_quoted: [lhs: lhs, rhs: rhs] do
      Monad.bind lhs, rhs
    end
  end

  @doc """
  The fmap or functor map operator.

  See `Functor.fmap/2` for more details.
  """
  defmacro lhs <|> rhs do
    quote bind_quoted: [lhs: lhs, rhs: rhs] do
      Functor.fmap rhs, lhs
    end
  end

  @doc """
  The apply operator.

  See `Applicative.apply/2` for more details.
  """
  defmacro lhs <~> rhs do
    quote bind_quoted: [lhs: lhs, rhs: rhs] do
      Applicative.apply rhs, lhs
    end
  end

  defmacro __using__(_) do
    quote do
      import Kernel, except: [<|>: 2, <~>: 2, ~>>: 2]
      import Monad.Operators
    end
  end
end
