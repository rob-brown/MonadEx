defimpl Functor, for: List do

  def fmap(list, fun) when is_function(fun, 1) do
    list |> Enum.map(fun)
  end
end

defimpl Applicative, for: List do

  def apply(list, list_fun) do
    Monad.bind(list_fun, &(Functor.fmap list, &1))
  end
end

 # ???: Should these implementations be moved to their respective files?

defimpl Monad, for: List do

  def bind(list, fun) when is_function(fun, 1) do
    list |> Enum.flat_map(fun)
  end
end
