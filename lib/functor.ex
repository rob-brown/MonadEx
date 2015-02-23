defprotocol Functor do
  @fallback_to_any true

  # Takes a function and a functor and returns a functor.
  # fmap :: (a -> b) -> f a -> f b
  # ((a -> b), functor<a>) -> functor<b>
  @spec fmap(t, (term -> term)) :: t
  def fmap(value, fun)
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
