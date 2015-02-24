defmodule Monad.State do
  use Monad.Behaviour

  # `fun` takes some state and return {value, new_state}
  defstruct fun: nil

  def state(fun) when is_function(fun, 1), do: %Monad.State{fun: fun}

  def runState(state), do: state.fun

  def return(value), do: state fn s -> {value, s} end

  def bind(state_monad, fun) when is_function(fun, 1) do
    state fn x ->
      {val1, state1} = (state_monad |> runState).(x)
      {val2, state2} = (val1 |> fun.() |> runState).(state1)
      {val2, state2}
    end
  end
end
