defmodule Monad.Maybe do

  defstruct type: :none, value: nil

  defmacro none, do: quote do: %Monad.Maybe{}
  def some(value), do: %Monad.Maybe{type: :some, value: value}
  def pure(value), do: some value

  defmacro none?(maybe) do
    quote do
      unquote(maybe) == none
    end
  end

  defmacro some?(maybe), do: not none?(maybe)

  defmacro __using__(_) do
    quote do
      import Monad.Maybe
    end
  end
end

defimpl Context, for: Monad.Maybe do
  def unwrap!(%Monad.Maybe{type: :some, value: value}), do: value
end

defimpl Functor, for: Monad.Maybe do
  use Monad.Maybe

  def fmap(maybe, fun) when none?(maybe) and is_function(fun, 1), do: maybe
  def fmap(maybe, fun) when some?(maybe) and is_function(fun, 1) do
    maybe |> Context.unwrap! |> fun.() |> pure
  end
end

defimpl Applicative, for: Monad.Maybe do
  use Monad.Maybe

  def apply(maybe, maybe_fun) do
    Monad.bind(maybe_fun, &(Functor.fmap maybe, &1))
  end
end

defimpl Monad, for: Monad.Maybe do
  use Monad.Maybe

  def bind(maybe, fun) when none?(maybe) and is_function(fun, 1), do: maybe
  def bind(maybe, fun) when some?(maybe) and is_function(fun, 1) do
    maybe |> Context.unwrap! |> fun.()
  end
end
