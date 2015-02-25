defmodule Monad.Maybe do
  @moduledoc """
  A monad that represents something or nothing.

  The concept of having something vs. nothing is similar to having a value vs.
  `nil`.
  """

  @typedoc """
  The possible types of values that can occur (i.e. something and nothing).
  """
  @type maybe_type :: :some | :none

  use Monad.Behaviour

  @opaque t :: %__MODULE__{type: maybe_type, value: term}
  @doc false
  defstruct type: :none, value: nil

  @doc """
  Returns a "nothing" state.
  """
  defmacro none, do: quote do: %Monad.Maybe{}

  @doc """
  Wraps the value into a maybe monad.

      iex> some 42
      %Monad.Maybe{type: :some, value: 42}
  """
  @spec some(term) :: t
  def some(value), do: %Monad.Maybe{type: :some, value: value}

  @doc """
  An alias for `some/1`.
  """
  @spec pure(term) :: t
  def pure(value), do: some value

  @doc """
  Unwraps the value from a maybe monad.

  Does not work with `none` values, since they contain nothing.

      iex> m = some 42
      iex> unwrap! m
      42
  """
  @spec unwrap!(t) :: term
  def unwrap!(%Monad.Maybe{type: :some, value: value}), do: value

  @doc """
  Macro that indicates if the maybe monad contains nothing.

  This macro may be used in guard clauses.

      iex> none? none
      true
      iex> none? some 42
      false
  """
  defmacro none?(maybe), do: quote do: unquote(maybe) == none

  @doc """
  Macro that indicates if the maybe monad contains something.

  This macro may be used in guard clauses.

      iex> some? none
      false
      iex> some? some 42
      true
  """
  defmacro some?(maybe), do: quote do: not none?(unquote maybe)

  @doc """
  Callback implementation of `Monad.Behaviour.return/1`.

  Wraps the value in a maybe monad.

      iex> return 42
      %Monad.Maybe{type: :some, value: 42}
  """
  @spec return(term) :: t
  def return(value), do: pure value

  @doc """
  Callback implementation of `Monad.Behaviour.bind/2`.

  If the monad contains a value, then the value is unwrapped and applied to
  `fun`.

  For `none` monads, `none` is returned without evaluating `fun`.

      iex> m = some 42
      iex> n = bind m, (& some &1 * 2)
      %Monad.Maybe{type: :some, value: 84}

      iex> bind none, (& some &1 * 2)
      none
  """
  @spec bind(t, (term -> t)) :: t
  def bind(maybe, fun) when none?(maybe) and is_function(fun, 1), do: maybe
  def bind(maybe, fun) when some?(maybe) and is_function(fun, 1) do
    maybe |> unwrap! |> fun.()
  end
end
