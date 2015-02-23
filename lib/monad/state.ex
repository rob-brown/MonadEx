defmodule Monad.State do

  # `fun` takes some state and return {value, new_state}
  defstruct fun: nil#, state: nil

  def state(fun) when is_function(fun, 1), do: %Monad.State{fun: fun}
  # def state(state, fun) when is_function(fun, 1), do: %Monad.State{fun: fun, state: state}

  def runState(state), do: state.fun

  def return(value), do: state fn s -> {value, s} end

  # def get(state), do: state.state

  # def put(state, value), do: %Monad.State{state | state: value} # ???: Is this right?

  defmacro __using__(_) do
    quote do
      import Monad.State
    end
  end
end

defimpl Context, for: Monad.State do
  def unwrap!(reader), do: reader.fun
end

defimpl Functor, for: Monad.State do
  use Monad.State

  # fmap :: (a -> b) -> f a -> f b
  # ((a -> b), f a) -> f b
  def fmap(_state_monad, fun) when is_function(fun, 1) do
    # {value, state} = state_monad |> runState
    # {new_value, new_state} = value |> fun.()
    # writer new_value, text <> new_text
  end
end

defimpl Applicative, for: Monad.State do
  use Monad.State

  def apply(_state_monad, _state_fun) do

    # {fun, text} = writer |> runWriter
    # {new_value, new_text} = Functor.fmap(writer, fun) |> runWriter
    # writer new_value, text <> new_text
  end
end

defimpl Monad, for: Monad.State do
  use Monad.State

  def bind(state_monad, fun) when is_function(fun, 1) do
    state fn x ->
      {val1, state1} = (state_monad |> runState).(x)
      {val2, state2} = (val1 |> fun.() |> runState).(state1)
      {val2, state2}
    end
  end
end
