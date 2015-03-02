defprotocol Applicative do
  @moduledoc """
  Applicative functors, or applicatives for short, are like functors, except
  they can apply more than one parameter. They do so by currying the function,
  and applying one parameter at a time (see `Curry`).

  Applicatives must also follow follow four laws: identity, composition,
  homomorphism, and interchange (see `Applicative.Law`).
  """

  @fallback_to_any true

  @doc """
  Takes an applicative holding a function and an applicative holding value and
  returns an applicative.

  (applicative<(b -> c)>, applicative<b>) -> applicative<c>
  """
  @spec apply(t, t) :: t
  def apply(value, fun)
end

defimpl Applicative, for: List do

  def apply(list, list_fun) do
    Monad.bind(list_fun, &(Functor.fmap list, &1))
  end
end

defimpl Applicative, for: Function do

  def apply(rhs_fun, lhs_fun) do
    &(&1 |> rhs_fun.() |> lhs_fun.())
  end
end

defimpl Applicative, for: Any do

  def apply(value, fun) do
    Monad.bind(fun, &(Functor.fmap value, &1))
  end
end
