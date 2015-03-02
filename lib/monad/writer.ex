defmodule Monad.Writer do
  @moduledoc """
  The writer monad keeps track of a calculation and a "log".

  The log can be anything that conforms to the `Monoid` protocol.

  It's often useful to combine the writer monad with others. For example, you
  can use a `Monad.Maybe` as the `value` of the writer monad. This offers the
  benefit of having a log of a writer monad and the control flow of a maybe
  monad.
  """

  use Monad.Behaviour

  @opaque t :: %__MODULE__{value: term, log: Monoid.t | :nil_monoid}
  @doc false
  defstruct value: nil, log: :nil_monoid

  @doc """
  Wraps `value` into a writer monad.

      iex> writer 42
      %Monad.Writer{value: 42, log: :nil_monoid}
  """
  @spec writer(term) :: t
  def writer(value), do: %Monad.Writer{value: value}

  @doc """
  Wraps `value` and `log` into a writer monad.

      iex> writer 42, "The answer"
      %Monad.Writer{value: 42, log: "The answer"}
  """
  @spec writer(term, Monoid.t) :: t
  def writer(value, log), do: %Monad.Writer{value: value, log: log}

  @doc """
  Returns the value and log from a writer monad.

      iex> w = writer 42, "The answer"
      iex> runWriter w
      {42, "The answer"}
  """
  @spec runWriter(t) :: {term, Monoid.t}
  def runWriter(writer), do: {writer.value, writer.log}

  @doc """
  Callback implementation of `Monad.Behaviour.return/1`.

  Wraps `value` into a writer monad.

      iex> return 42
      %Monad.Writer{value: 42, log: :nil_monoid}
  """
  @spec return(term) :: t
  def return(value), do: writer value

  @doc """
  Callback implementation of `Monad.Behaviour.bind/2`.

  Unwraps the value from `writer` and applies it to `fun`. The log from `writer`
  and from the resulting writer monad are combined.

      iex> m = writer 4, ["Four"]
      iex> n = bind m, (& writer &1 * 2, ["Doubled"])
      iex> runWriter n
      {8, ["Four", "Doubled"]}
  """
  @spec bind(t, (term -> t)) :: t
  def bind(writer, fun) when is_function(fun, 1) do
    {val1, monoid1} = writer |> runWriter
    {val2, monoid2} = val1 |> fun.() |> runWriter
    writer val2, merge_monoids(monoid1, monoid2)
  end

  ## Helpers

  # `merge_monoids` is necessary because Elixir doesn't have a strong, static type system.
  # :nil_monoid basically acts like a universal "zero".
  defp merge_monoids(:nil_monoid, :nil_monoid), do: :nil_monoid
  defp merge_monoids(monoid, :nil_monoid), do: monoid
  defp merge_monoids(:nil_monoid, monoid), do: monoid
  defp merge_monoids(monoid1, monoid2), do: Monoid.mappend(monoid1, monoid2)
end
