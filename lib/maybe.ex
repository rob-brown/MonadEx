defmodule Monad.Maybe do

  defstruct type: :none, value: nil

  defmacro none, do: quote do: %Monad.Maybe{}
  def some(value), do: %Monad.Maybe{type: :some, value: value}
  def pure(value), do: some value

  def unwrap!(%Monad.Maybe{type: :some, value: value}), do: value

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

defimpl Monad, for: Monad.Maybe do
  use Monad.Maybe

  def bind(maybe, fun) when none?(maybe) and is_function(fun, 1), do: maybe
  def bind(maybe, fun) when some?(maybe) and is_function(fun, 1) do
    maybe |> unwrap! |> fun.()
  end

  def flat_map(maybe, fun) when none?(maybe) and is_function(fun, 1), do: maybe
  def flat_map(maybe, fun) when some?(maybe) and is_function(fun, 1) do
    maybe |> unwrap! |> fun.() |> pure
  end

  def apply(maybe, maybe_fun) do
    bind(maybe_fun, &(flat_map maybe, &1))
  end
end
