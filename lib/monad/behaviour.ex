defmodule Monad.Behaviour do
  @moduledoc """
  A behaviour that provides the common code for monads.

  Creating a monad consists of three steps:
  1. Call `use Monad.Behaviour`
  2. Implement `return/1`
  3. Implement `bind/2`

  By completing the above steps, the monad will automatically conform to the
  `Functor` and `Applicative` protocols in addition to the `Monad` protocol.

  ## Example

  The following is an example showing how to use `Monad.Behaviour`.

      iex> defmodule Monad.Identity.Sample do
      ...>   use Elixir.Monad.Behaviour  # The `Elixir` prefix is needed for the doctest.
      ...>
      ...>   defstruct value: nil
      ...>
      ...>   def return(value) do
      ...>     %Monad.Identity.Sample{value: value}
      ...>   end
      ...>
      ...>   def bind(%Monad.Identity.Sample{value: value}, fun) do
      ...>     fun.(value)
      ...>   end
      ...>
      ...>   def unwrap(%Monad.Identity.Sample{value: value}) do
      ...>     value
      ...>   end
      ...> end
      iex> m = Monad.Identity.Sample.return 42
      iex> Monad.Identity.Sample.unwrap m
      42
      iex> m2 = Elixir.Monad.bind m, (& Monad.Identity.Sample.return &1 * 2)
      iex> Monad.Identity.Sample.unwrap m2
      84
  """

  use Behaviour

  @type t :: Monad.t
  @type bind_fun :: (term -> t)

  defcallback return(value :: term) :: t
  defcallback bind(monad :: t, fun :: bind_fun) :: t

  @doc """
  Calls `module`'s `return/1` function.

  Wraps the given value in the specified monad.
  """
  @spec return(atom, term) :: t
  def return(module, value), do: module.return(value)

  @doc """
  Calls `module`'s `bind/2` function.

  Unwraps `monad` then applies the wrapped value to `fun`. Returns a new monad.
  """
  @spec bind(atom, t, (term -> t)) :: t
  def bind(module, monad, fun), do: module.bind(monad, fun)

  @doc false
  defmacro __using__(_) do
    quote do
      @behaviour Monad.Behaviour

      defimpl Functor, for: __MODULE__ do
        def fmap(monad, fun) do
          return = (& Monad.Behaviour.return @for, &1)
          Monad.Behaviour.bind @for, monad, (& &1 |> fun.() |> return.())
        end
      end

      defimpl Applicative, for: __MODULE__ do
        def apply(monad, monad_fun) do
          Monad.Behaviour.bind @for, monad_fun, (& Functor.fmap monad, &1)
        end
      end

      defimpl Monad, for: __MODULE__ do
        def bind(monad, fun) do
          Monad.Behaviour.bind @for, monad, fun
        end
      end
    end
  end
end
