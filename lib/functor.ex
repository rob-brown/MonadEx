defprotocol Functor do
  @moduledoc """
  > Functors are mappings or homomorphisms between categories
  –[Wikipedia](https://en.wikipedia.org/wiki/Functor)

  Functors always take one parameter. They also preserve identity and
  composition (see `Functor.Law`).
  """

  @fallback_to_any true

  @doc """
  Takes a function and a functor and returns a functor.

  In Haskell types: fmap :: (a -> b) -> f a -> f b
  """
  @spec fmap(t, (term -> term)) :: t
  def fmap(value, fun)
end

defimpl Functor, for: List do

  def fmap(list, fun) when is_function(fun, 1) do
    list |> Enum.map(fun)
  end
end

defimpl Functor, for: Function do

  def fmap(lhs_fun, rhs_fun) do
    &(&1 |> lhs_fun.() |> rhs_fun.())
  end
end

defimpl Functor, for: Any do

  def fmap(nil, fun) when is_function(fun, 1), do: nil
  def fmap(value, fun) when is_function(fun, 1) do
    fun.(value)
  end
end
