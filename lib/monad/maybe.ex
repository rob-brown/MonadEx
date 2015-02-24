defmodule Monad.Maybe do
  use Monad.Behaviour

  defstruct type: :none, value: nil

  defmacro none, do: quote do: %Monad.Maybe{}
  def some(value), do: %Monad.Maybe{type: :some, value: value}
  def pure(value), do: some value

  def unwrap!(%Monad.Maybe{type: :some, value: value}), do: value

  defmacro none?(maybe), do: quote do: unquote(maybe) == none

  defmacro some?(maybe), do: not none?(maybe)

  def return(value), do: pure value

  def bind(maybe, fun) when none?(maybe) and is_function(fun, 1), do: maybe
  def bind(maybe, fun) when some?(maybe) and is_function(fun, 1) do
    maybe |> unwrap! |> fun.()
  end
end
