defmodule Monad.State do
  @moduledoc """
  Like `Monad.Reader`, the state monad can share an environment between
  different operations. Additionally, it can store an arbitrary value.

  ## Example

      iex> use Monad.Operators
      iex> env = %{dev: %{url: "http://www.example.com/dev"}, prod: %{url: "https://www.example.com/prod"}}
      iex> s = state(&{env, &1})
      ...> ~>> (fn x -> state(&{x[&1], &1}) end)
      ...> ~>> (fn x -> state(&{x[:url], &1}) end)
      ...> ~>> (fn x -> state(&{x <> "/index.html", &1}) end)
      iex> fun = runState s
      iex> fun.(:dev)
      {"http://www.example.com/dev/index.html", :dev}
      iex> fun.(:prod)
      {"https://www.example.com/prod/index.html", :prod}

      iex> import Curry
      iex> state = curry(& &1 + &2) <|> state(& {5, &1 * 2}) <~> state(& {9, &1 * &1})
      iex> fun = runState state
      iex> fun.(2)
      {14, 16}
      iex> fun.(-12)
      {14, 576}
  """

  use Monad.Behaviour

  @opaque t :: %__MODULE__{fun: (term -> {term, term})}
  @doc false
  defstruct fun: nil

  @doc """
  Wraps `fun` in a state monad.

      iex> s = state &{&1 * 2, "Doubled"}
      iex> s.fun.(42)
      {84, "Doubled"}
  """
  @spec state((term -> {term, term})) :: t
  def state(fun) when is_function(fun, 1), do: %Monad.State{fun: fun}

  @doc """
  Returns the function wrapped in the state monad.

      iex> s = state &{&1 * 2, "Doubled"}
      iex> fun = runState s
      iex> fun.(42)
      {84, "Doubled"}
  """
  @spec runState(t) :: (term -> {term, term})
  def runState(state), do: state.fun

  @doc """
  Callback implementation of `Monad.Behaviour.return/1`.

  Converts `value` into function that takes some state and returns the value
  as-is and the state. Then the function is wrapped into a state monad.

      iex> s = return 42
      iex> fun = runState s
      iex> fun.("My state")
      {42, "My state"}
  """
  @spec return(term) :: t
  def return(value), do: state(fn s -> {value, s} end)

  @doc """
  Callback implementation of `Monad.Behaviour.bind/2`.

      iex> s1 = state &{&1 <> "!", &1}
      iex> s2 = bind(s1, fn x -> state(fn s -> {x <> "?", s} end) end)
      iex> fun = runState s2
      iex> fun.("State")
      {"State!?", "State"}
  """
  @spec bind(t, (term -> t)) :: t
  def bind(state_monad, fun) when is_function(fun, 1) do
    state(fn x ->
      {val1, state1} = (state_monad |> runState).(x)
      {val2, state2} = (val1 |> fun.() |> runState).(state1)
      {val2, state2}
    end)
  end
end
