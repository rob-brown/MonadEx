defmodule Monad.Writer do
  use Monad.Behaviour

  @opaque t :: %__MODULE__{value: term, log: Monoid.t | :nil_monoid}
  @doc false
  defstruct value: nil, log: :nil_monoid

  def writer(value), do: %Monad.Writer{value: value}
  def writer(value, log), do: %Monad.Writer{value: value, log: log}

  def runWriter(writer), do: {writer.value, writer.log}

  def return(value), do: writer value

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
