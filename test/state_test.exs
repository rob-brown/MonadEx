defmodule State.Test do
  use ExUnit.Case, async: true
  use Monad.Operators
  use Monad.State
  use Curry

  test "bind once" do
    state = state(fn s -> {0, s * s} end)
              ~>> fn x -> state fn s -> assert x == 0 and s == 16; {42, s * 2} end end
    assert runState(state).(4) == {42, 32}
  end

  test "bind once with return" do
    state = return(1)
              ~>> fn x -> assert x == 1; return x end
    assert runState(state).(42) == {1, 42}
  end

  test "bind once with return and a change" do
    state = return(1)
              ~>> fn x -> assert x == 1; return 24 end
    assert runState(state).(42) == {24, 42}
  end

  test "bind twice" do
    state = state(fn s -> {10, s * s} end)
              ~>> fn x -> state fn s -> assert x == 10 and s == 16; {x * 2, 12} end end
              ~>> fn x -> return x - 1 end
    assert runState(state).(4) == {19, 12}
  end

end
