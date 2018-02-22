defmodule Monad.Error do
  @moduledoc """
  A monad that represents an error or an OK.

  A similar representation of {:ok, value} and {:error, message}.
  """

  @typedoc """
  The possible types of values that can occur (i.e. ok and error).
  """
  @type error_type :: :error | :ok

  use Monad.Behaviour

  @opaque t :: %__MODULE__{type: error_type, value: any}

  @doc false
  defstruct type: :ok, value: nil

  @doc """
  Returns an empty "ok" monad.
  """
  defmacro default, do: quote(do: %Monad.Error{type: :ok})

  @doc """
  Wraps the value into an "ok" monad.
  """
  @spec ok(term) :: t
  def ok(v), do: %Monad.Error{type: :ok, value: v}


  @doc """
  Wraps the value into an "error" monad.
  """
  @spec error(term) :: t
  def error(r), do: %Monad.Error{type: :error, value: r}

  @doc """
  Unwraps the value from an "ok" monad.

  Does not work with "error" values, since they contain an error message.

      iex> m = ok(42)
      iex> unwrap! m
      42
  """
  @spec unwrap!(t) :: any
  def unwrap!(%Monad.Error{type: :ok, value: t}), do: t

  @doc """
  Unwraps the message from an "error" monad.

  Does not work with "ok" values, since they contain a value.

      iex> m = error("Some error message")
      iex> message m
      "Some error message"
  """
  @spec message(t) :: any
  def message(%Monad.Error{type: :error, value: r}), do: r

  @doc """
  Macro that indicates if the error monad is "ok"

  This macro may be used in guard clauses.

      iex> ok? default()
      true
      iex> ok? error("message")
      false
  """
  defmacro ok?(monad), do: quote(do: %{unquote(monad) | value: nil} == default())

  @doc """
  Macro that indicates if the error monad is "error"

  This macro may be used in guard clauses.

      iex> error? default()
      false
      iex> error? error("message")
      true
  """
  defmacro error?(monad), do: quote(do: not ok?(unquote(monad)))

  @doc """
  Callback implementation of `Monad.Behaviour.return/1`.

  Wraps the value in an "ok" error monad.

      iex> return 42
      %Monad.Error{type: :ok, value: 42}
  """
  @spec return(term) :: t
  def return(v), do: ok(v)

  @doc """
  Callback implementation of `Monad.Behaviour.bind/2`.

  If the monad is "ok", then the value is unwrapped and applied to
  `fun`.

  For "error" monads, it is returned without evaluating `fun`.

      iex> m = ok(42)
      iex> bind m, (& ok &1 * 2)
      %Monad.Error{type: :ok, value: 84}

      iex> bind error("error"), (& ok &1 * 2)
      %Monad.Error{type: :error, value: "error"}
  """
  def bind(monad, fun) when error?(monad) and is_function(fun, 1), do: monad

  def bind(monad, fun) when ok?(monad) and is_function(fun, 1) do
    monad |> unwrap! |> fun.()
  end
end
