defprotocol Monad do
  @fallback_to_any true

  # Takes a monad value and a function that returns a monad and returns a monad.
  # (>>=) :: m a -> (a -> m b) -> m b
  # (monad<a>, (a -> monad<b>)) -> monad<b>
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
