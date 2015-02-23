defmodule Monad.Reader do

  defstruct fun: nil

  def reader(fun), do: %Monad.Reader{fun: fun}

  def runReader(reader), do: reader.fun

  def return(value), do: %Monad.Reader{fun: fn _ -> value end}

  # def ask, do: %Monad.Reader{fun: &(&1)}

  defmacro __using__(_) do
    quote do
      import Monad.Reader
    end
  end
end

defimpl Context, for: Monad.Reader do
  def unwrap!(reader), do: reader.fun
end

# defimpl Functor, for: Monad.Reader do
#   use Monad.Reader
#
#   def fmap(_reader, fun) when is_function(fun, 1) do
#     # {value, text} = writer |> runWriter
#     # {new_value, new_text} = value |> fun.()
#     # writer new_value, text <> new_text
#   end
# end
#
# defimpl Applicative, for: Monad.Reader do
#   use Monad.Reader
#
#   def apply(_reader, _reader_fun) do
#     # {fun, text} = writer |> runWriter
#     # {new_value, new_text} = Functor.fmap(writer, fun) |> runWriter
#     # writer new_value, text <> new_text
#   end
# end

defimpl Monad, for: Monad.Reader do
  use Monad.Reader

  def bind(reader, fun) when is_function(fun, 1) do
    reader fn x ->
      fun1 = reader |> runReader
      fun2 = x |> fun1.() |> fun.() |> runReader
      fun2.(x)
    end
  end
end
