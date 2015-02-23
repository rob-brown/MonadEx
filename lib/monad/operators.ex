defmodule Monad.Operators do

  defmacro lhs ~>> rhs do
    quote bind_quoted: [lhs: lhs, rhs: rhs] do
      Monad.bind lhs, rhs
    end
  end

  defmacro lhs <|> rhs do
    quote bind_quoted: [lhs: lhs, rhs: rhs] do
      Functor.fmap rhs, lhs
    end
  end

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
