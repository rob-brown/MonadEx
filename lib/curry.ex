defmodule Curry do
  @moduledoc """
  Simple module for currying functions.
  """

  @doc """
  Curries a given function.

  A function that would normally take three parameters, for example, will take
  three individual parameters instead. The curry macro works with anonymous
  functions and captured named functions.

  ## Examples

      iex> fun3 = &(&1 + &2 + &3)
      iex> fun3.(3, 4, 5)
      12
      iex> curried3 = curry(fun3)
      iex> curried3.(3).(4).(5)
      12

      iex> defmodule Curry.Sample do
      ...>   def uncurried(x, y, z) do
      ...>     x + y + z
      ...>   end
      ...> end
      iex> Curry.Sample.uncurried(3, 4, 5)
      12
      iex> captured3 = curry &Curry.Sample.uncurried/3
      iex> captured3.(3).(4).(5)
      12
  """
  defmacro curry(fun) do
    quote do: Curry.Helper.curry(unquote(fun))
  end
end

defmodule Curry.Helper do
  @moduledoc false

  @doc false
  @spec curry((... -> term)) :: (term -> term)
  def curry(fun) when is_function(fun, 0), do: fun
  def curry(fun) when is_function(fun), do: curry(fun, arity(fun), [])

  @doc false
  defp curry(fun, 0, args), do: apply(fun, Enum.reverse(args))
  defp curry(fun, n, args), do: &curry(fun, n - 1, [&1 | args])

  @doc false
  defp arity(f) when is_function(f), do: arity(f, 0)
  defp arity(f, n) when is_function(f, n), do: n
  defp arity(f, n), do: arity(f, n + 1)
end
