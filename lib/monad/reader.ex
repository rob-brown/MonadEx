defmodule Monad.Reader do
  @moduledoc """
  The reader monad is great for situations when you need to share some
  environment or state between several operations.

  Reader monads are great for dependency injection. The environment is specified
  separately from the operations.

  ## Example

      iex> import Curry
      iex> use Monad.Operators
      iex> env = %{dev: %{url: "http://www.example.com/dev"}, prod: %{url: "https://www.example.com/prod"}}
      iex> r = reader(& env[&1])
      ...> ~>> (& return(&1[:url]))
      ...> ~>> (& return(&1 <> "/index.html"))
      iex> fun = runReader r
      iex> fun.(:dev)
      "http://www.example.com/dev/index.html"
      iex> fun.(:prod)
      "https://www.example.com/prod/index.html"

      iex> reader = curry(& &1 + &2) <|> reader(& &1 * 2) <~> reader(& &1 * &1)
      iex> fun = runReader reader
      iex> fun.(2)
      8
      iex> fun.(-12)
      120
  """

  use Monad.Behaviour

  @opaque t :: %__MODULE__{fun: (term -> term)}
  @doc false
  defstruct fun: nil

  @doc """
  Wraps `fun` in a reader monad.

      iex> r = reader &(&1)
      iex> r.fun.(4)
      4
  """
  @spec reader((term -> term)) :: t
  def reader(fun), do: %Monad.Reader{fun: fun}

  @doc """
  Unwraps the function from the reader.

     iex> r = reader &(&1 * 2)
     iex> f = runReader r
     iex> f.(3)
     6
  """
  @spec runReader(t) :: (term -> term)
  def runReader(reader), do: reader.fun

  @doc """
  Callback implementation of `Monad.Behaviour.return/1`.

  Converts `value` into a function that always returns `value`. Then wraps that
  function into a reader monad.

      iex> r = return 42
      iex> r.fun.(:unused)
      42
  """
  @spec return(term) :: t
  def return(value), do: %Monad.Reader{fun: fn _ -> value end}

  @doc """
  Callback implementation of `Monad.Behaviour.bind/2`.

      iex> r = reader &(&1 * 2)
      iex> bind r, &(&1 + 3)
      iex> f = runReader r
      iex> f.(10)
      20
  """
  @spec bind(t, (term -> t)) :: t
  def bind(reader, fun) when is_function(fun, 1) do
    reader(fn x ->
      fun1 = reader |> runReader
      fun2 = x |> fun1.() |> fun.() |> runReader
      fun2.(x)
    end)
  end
end
