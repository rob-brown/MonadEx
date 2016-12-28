defmodule Test.Monad.Aggregate.Commands do
  defmodule Add,      do: defstruct [amount: nil]
  defmodule Subtract, do: defstruct [amount: nil]
end

defmodule Test.Monad.Aggregate.Events do
  defmodule Added,      do: defstruct [amount: nil]
  defmodule Subtracted, do: defstruct [amount: nil]
end

defmodule Test.Monad.Aggregate.InstanceTest do
  alias Test.Monad.Aggregate.InstanceTest, as: Aggregate
  alias Test.Monad.Aggregate.Commands.{Add, Subtract}
  alias Test.Monad.Aggregate.Events.{Added, Subtracted}

  defstruct [value: 0]

  def execute(%Aggregate{}, %Add{amount: amount}),                   do: %Added{amount: amount}
  def execute(%Aggregate{}, %Subtract{amount: amount}),              do: %Subtracted{amount: amount}
  def apply(%Aggregate{value: value}, %Added{amount: amount}),      do: %Aggregate{value: value + amount}
  def apply(%Aggregate{value: value}, %Subtracted{amount: amount}), do: %Aggregate{value: value - amount}
end

defmodule Aggregate.Test do
  use ExUnit.Case
  use Monad.Operators
  import Monad.Law
  import Monad.Aggregate
  alias Test.Monad.Aggregate.InstanceTest, as: A
  alias Test.Monad.Aggregate.Commands.{Add, Subtract}
  alias Test.Monad.Aggregate.Events.{Added, Subtracted}

  test "monad aggregate" do
    state = %A{}
    a_events = A.execute(state, %Add{amount: 4})
    s_events = A.execute(state, %Subtract{amount: 3})
    a = &(aggregate(&1, a_events))
    s = &(aggregate(&1, s_events))
    assert left_identity?(%A{}, &return/1, a)
    assert right_identity?(aggregate(state, a_events), &return/1)
    assert associativity?(aggregate(state), a, s)
  end

  test "calculations one-by-one" do
    aggregate =    return(%A{})
               ~>> exec(%Add{amount: 4})
               ~>> exec(%Subtract{amount: 3})
               ~>> exec(%Add{amount: 5})
               ~>> exec(%Subtract{amount: 3})
    assert state(aggregate).value == 3
    assert [%Added{amount: 4},
            %Subtracted{amount: 3},
            %Added{amount: 5},
            %Subtracted{amount: 3}] = events(aggregate)
  end

  test "calculation list" do
    aggregate =    return(%A{})
               ~>> exec([%Add{amount: 4},
                         %Subtract{amount: 3},
                         %Add{amount: 5},
                         %Subtract{amount: 3}])
    assert state(aggregate).value == 3
    assert [%Added{amount: 4},
            %Subtracted{amount: 3},
            %Added{amount: 5},
            %Subtracted{amount: 3}] = events(aggregate)
  end

end
