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
    quote do: Curry.Helper.curry unquote(fun)
  end
end

defmodule Curry.Helper do
  @moduledoc false

  @doc false
  @spec curry((... -> term)) :: (term -> term)
  def curry(fun) when is_function(fun, 0) or is_function(fun, 1) do
    fun
  end
  def curry(fun) when is_function(fun, 2) do
    fn a -> fn b -> fun.(a, b) end end
  end
  def curry(fun) when is_function(fun, 3) do
    fn a -> fn b -> fn c -> fun.(a, b, c) end end end
  end
  def curry(fun) when is_function(fun, 4) do
    fn a -> fn b -> fn c -> fn d -> fun.(a, b, c, d) end end end end
  end
  def curry(fun) when is_function(fun, 5) do
    fn a -> fn b -> fn c -> fn d -> fn e -> fun.(a, b, c, d, e) end end end end end
  end
  def curry(fun) when is_function(fun, 6) do
    fn a -> fn b -> fn c -> fn d -> fn e -> fn f -> fun.(a, b, c, d, e, f) end end end end end end
  end
  def curry(_fun), do: IO.puts "Too many parameters."
end
