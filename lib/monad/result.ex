defmodule Monad.Result do
  @moduledoc """
  A monad that represents success and failure conditions.

  In a series of bind operations, if any function returns an error monad, the
  following binds are skipped. This allows for easy flow control for both
  success and error cases.
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

      iex> s = success 42
      iex> s.value
      42
      iex> s.error
      nil
  """
  @spec success(term) :: t
  def success(value), do: %Monad.Result{type: :ok, value: value}

  @doc """
  Wraps a value in an error monad.

      iex> e = error "Failed"
      iex> e.value
      nil
      iex> e.error
      "Failed"
  """
  @spec error(term) :: t
  def error(error), do: %Monad.Result{type: :error, error: error}

  @doc """
  Returns true if the given monad contains a success state.

      iex> s = success 42
      iex> success? s
      true
  """
  @spec success?(t) :: boolean
  def success?(result), do: result.type == :ok

  @doc """
  Returns true if the given monad contains an error state.

      iex> e = error "Failed"
      iex> error? e
      true
  """
  @spec error?(t) :: boolean
  def error?(result), do: result.type == :error

  @doc """
  Converts a standard success/failure tuple to a `Monad.Result`.

      iex> s = from_tuple {:ok, 42}
      iex> s.value
      42
      iex> s.error
      nil

      iex> e = from_tuple {:error, "Failed"}
      iex> e.value
      nil
      iex> e.error
      "Failed"
  """
  @spec from_tuple(result_tuple) :: t
  def from_tuple({:ok, value}), do: success value
  def from_tuple({:error, reason}), do: error reason

  @doc """
  Converts the `Monad.Result` to a tagged tuple.

      iex> s = success 42
      iex> to_tuple s
      {:ok, 42}

      iex> e = error :badarg
      iex> to_tuple e
      {:error, :badarg}
  """
  @spec to_tuple(t) :: result_tuple
  def to_tuple(%__MODULE__{type: :ok, value: value}), do: {:ok, value}
  def to_tuple(%__MODULE__{type: :error, error: error}), do: {:error, error}

  @doc """
  Unwraps the value from a success monad.

  Does not work with error monads.

      iex> s = success 42
      iex> unwrap! s
      42
  """
  @spec unwrap!(t) :: term
  def unwrap!(%Monad.Result{type: :ok, value: value}), do: value

  @doc """
  Callback implementation of `Monad.Behaviour.return/1`.

  Wraps a value in a success monad.

      iex> s = return 42
      iex> s.value
      42
      iex> s.error
      nil
  """
  @spec return(term) :: t
  def return(value), do: success value

  @doc """
  Callback implementation of `Monad.Behaviour.bind/2`.

  If the monad contains a success state, then the value is unwrapped and applied
  to `fun`.

  For monads containing an error state, the error is returned as is.

      iex> s = success 42
      iex> r = bind s, (& success &1 * 2)
      iex> r.value
      84
      iex> r.error
      nil

      iex> s = success 42
      iex> r = bind s, fn _ -> error "Failed" end
      iex> r.value
      nil
      iex> r.error
      "Failed"
  """
  @spec bind(t, (term -> t)) :: t
  def bind(result = %Monad.Result{type: :error}, _fun), do: result
  def bind(result = %Monad.Result{type: :ok}, fun) when is_function(fun, 1) do
      result |> unwrap! |> fun.()
  end
end
