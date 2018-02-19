defprotocol Monad do
  @moduledoc """
  > Monads are structures that represent computations as sequences of steps.
  –[Wikipedia](https://en.wikipedia.org/wiki/Monad_(functional_programming)

  Monads are also able to encapsulate side-effects, such as IO and failure.
  Monads have two primary functions: `bind` and `return`. This protocol does not
  contain a `return` function due to the limitations of Elixir protocols.
  However, `return` can be found in `Monad.Behaviour`.
  """

  @fallback_to_any true

  @doc """
  Takes a monad value and a function that takes a value and returns a monad.

  In Haskell types: (>>=) :: m a -> (a -> m b) -> m b
  """
  @spec bind(t, (term -> t)) :: t
  def bind(value, fun)
end

defimpl Monad, for: List do
  def bind(list, fun) when is_function(fun, 1) do
    list |> Enum.flat_map(fun)
  end
end

defimpl Monad, for: Any do
  def bind(nil, fun) when is_function(fun, 1), do: nil

  def bind(value, fun) when is_function(fun, 1) do
    fun.(value)
  end
end
