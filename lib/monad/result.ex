defmodule Monad.Result do
  @moduledoc """
  A monad that represents success and failure conditions.

  In a series of bind operations, if any function returns an error monad, the following binds are skipped. This allows for easy flow control for both success and error cases.
  """

  @typedoc """
  The possible types of results that can occur (i.e. success and failure).
  """
  @type result_type :: :ok | :error

  @typedoc """
  The standard tuple format for representing success and error states.

  These tuples are easily converted to a `Monad.Result`.
  """
  @type result_tuple :: {result_type, term}

  use Monad.Behaviour

  @opaque t :: %__MODULE__{type: result_type, value: term, error: term}
  @doc false
  defstruct type: :ok, value: nil, error: nil

  @doc """
  Wraps a value in a success monad.
  """
  @spec success(term) :: t
  def success(value), do: %Monad.Result{type: :ok, value: value}

  @doc """
  Wraps a value in an error monad.
  """
  @spec error(term) :: t
  def error(error), do: %Monad.Result{type: :error, error: error}

  @doc """
  Returns true if the given monad contains a success state.
  """
  @spec success?(t) :: boolean
  def success?(result), do: result.type == :ok

  @doc """
  Returns true if the given monad contains an error state.
  """
  @spec error?(t) :: boolean
  def error?(result), do: result.type == :error

  @doc """
  Converts a standard success/failure tuple to a `Monad.Result`.
  """
  @spec from_tuple(result_tuple) :: t
  def from_tuple({:ok, value}), do: success value
  def from_tuple({:error, reason}), do: error reason

  @doc """
  Unwraps the value from a success monad.

  Does not work with error monads.
  """
  @spec unwrap!(t) :: term
  def unwrap!(%Monad.Result{type: :ok, value: value}), do: value

  @doc """
  Wraps a value in a success monad.
  """
  @spec return(term) :: t
  def return(value), do: success value

  @doc """
  If the monad contains a success state, then the value is unwrapped and applied to `fun`.

  For monads containing an error state, the error is returned as is.
  """
  @spec bind(t, (term -> t)) :: t
  def bind(result = %Monad.Result{type: :error}, _fun), do: result
  def bind(result = %Monad.Result{type: :ok}, fun) when is_function(fun, 1) do
      result |> unwrap! |> fun.()
  end
end
