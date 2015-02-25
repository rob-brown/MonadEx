defmodule Monad.Reader do
  use Monad.Behaviour

  @opaque t :: %__MODULE__{fun: (term -> term)}
  @doc false
  defstruct fun: nil

  def reader(fun), do: %Monad.Reader{fun: fun}

  def runReader(reader), do: reader.fun

  def return(value), do: %Monad.Reader{fun: fn _ -> value end}

  def bind(reader, fun) when is_function(fun, 1) do
    reader fn x ->
      fun1 = reader |> runReader
      fun2 = x |> fun1.() |> fun.() |> runReader
      fun2.(x)
    end
  end
end
