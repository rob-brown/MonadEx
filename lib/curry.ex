defmodule Curry do

  defmacro curry(fun) do
    quote do: Curry.Helper.curry unquote(fun)
  end

  defmacro __using__(_) do
    quote do
      import Curry
    end
  end
end

defmodule Curry.Helper do
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
