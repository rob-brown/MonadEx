defprotocol Applicative do
  @fallback_to_any true

  # Takes an applicative function and an applicative value and returns an applicative.
  # (applicative<(b -> c)>, applicative<b>) -> applicative<c>
  @spec apply(t, t) :: t
  def apply(value, fun)

  # How will this work if I don't know the type?
  # def pure(module, value)
end

# TODO: Test the applicative impl for functions.

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

  # def pure(module, value) do
  #   module.pure(value)
  # end

  def apply(value, fun) do
    Monad.bind(fun, &(Functor.fmap value, &1))
  end
end
