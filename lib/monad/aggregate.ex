defmodule Monad.Aggregate do
  @moduledoc """
  This is an aggregate monad.
  For using this monad just create your aggregate with:
    ** *handle* functions for commands
    ** *apply* functions for the events.
    ** ** defstruct for the state structure definition
  Check the example in the test file.
  """
  use Monad.Behaviour

  @enforce_keys [:state]
  defstruct state: nil, events: []

# Behaviour
  def return(state), do: aggregate state
  def bind(monad, fun) do
    new_monad = monad |> state |> fun.()
    %__MODULE__{new_monad | events: monad.events ++ new_monad.events}
  end

# API
  @doc "This helper is the monad return/pure function. A Monad is created with the given state and an empty list of events"
  def aggregate(state), do: %__MODULE__{state: state}

  @doc "This helper apply given events to a given state and return a new monad with the derived state and it's events"
  def aggregate(state, events) do
    derived_state = %__MODULE__{state: state, events: events} |> derive_state
    %__MODULE__{state: derived_state, events: List.wrap(events)}
  end

  @doc "This helper is used for handling commands that will create and apply their emmited events"
  def exec(cmds) do
    cmds = cmds |> List.wrap
    & Enum.reduce(cmds, return(&1),
      fn cmd, monad ->
        new_monad = aggregate(monad.state, handle(monad.state, cmd))
        %__MODULE__{state: new_monad.state, events: monad.events ++ new_monad.events}
      end)
  end

  @doc "This helper is used for extracting the aggregate state from the monad"
  def state( monad), do: monad.state

  @doc "This helper is used for extracting the aggregate events from the monad"
  def events(monad), do: monad.events

  defp derive_state(monad), do:
    Enum.reduce List.wrap(monad.events), monad.state, &apply_event/2

  defp apply_event(event, state), do:
    state.__struct__.apply(state, event)

  defp handle(state,cmd), do:
    List.wrap(state.__struct__.handle(state, cmd))

end
