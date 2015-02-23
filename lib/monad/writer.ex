defmodule Monad.Writer do

  defstruct value: nil, monoid: :nil_monoid

  def writer(value), do: %Monad.Writer{value: value}
  def writer(value, monoid), do: %Monad.Writer{value: value, monoid: monoid}

  def runWriter(writer), do: {writer.value, writer.monoid}

  def return(value), do: writer value

  # def tell(writer, value), do: %Monad.Writer{writer | monoid: Monoid.mappend(writer.monoid, value)}  # ???: Is this right?

  defmacro __using__(_) do
    quote do
      import Monad.Writer
    end
  end
end

defimpl Context, for: Monad.Writer do
  def unwrap!(writer), do: {writer.value, writer.monoid}
end

defimpl Functor, for: Monad.Writer do
  use Monad.Writer

  def fmap(writer, fun) when is_function(fun, 1) do
    {value, monoid} = writer |> runWriter
    {new_value, new_log} = value |> fun.()  # ???: What do I do about curried functions?
    writer new_value, Monoid.mappend(monoid, new_log)
  end
end

# defimpl Applicative, for: Monad.Writer do
#   use Monad.Writer
#
#   def apply(writer, writer_fun) do
#     {fun, monoid} = writer |> runWriter
#     {new_value, new_log} = Functor.fmap(writer, fun) |> runWriter
#     writer new_value, Monoid.mappend(monoid, new_log)
#   end
# end

defimpl Monad, for: Monad.Writer do
  use Monad.Writer

  def bind(writer, fun) when is_function(fun, 1) do
    {val1, monoid1} = writer |> runWriter
    {val2, monoid2} = val1 |> fun.() |> runWriter
    if monoid1 == :nil_monoid do
      writer val2, monoid2
    else
      writer val2, Monoid.mappend(monoid1, monoid2)
    end
  end
end
