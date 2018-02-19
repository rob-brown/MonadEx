defmodule State.Test do
  use ExUnit.Case, async: true
  use Monad.Operators
  import Curry
  import Monad.State

  doctest Monad.State

  test "simple fmap" do
    state = (& &1) <|> return(42)
    assert runState(state).("Some environment") == {42, "Some environment"}
  end

  test "fmap with state modification" do
    state = (&(&1 * 2)) <|> state(&{42, "Hello, " <> &1})
    assert runState(state).("World") == {84, "Hello, World"}
  end

  test "apply two" do
    state = curry(&(&1 + &2)) <|> return(4) <~> return(5)
    assert runState(state).("Some environment") == {9, "Some environment"}
  end

  test "apply two with state modification" do
    state = curry(&(&1 + &2)) <|> state(&{4, &1 <> "!"}) <~> state(&{5, &1 <> "?"})
    assert runState(state).("State") == {9, "State!?"}
  end

  test "apply three with state modification" do
    state =
      curry(&(&1 + &2 + &3))
      <|> state(&{4, &1 <> "!"})
      <~> state(&{5, &1 <> "?"})
      <~> state(&{6, "«#{&1}»"})

    assert runState(state).("State") == {15, "«State!?»"}
  end

  test "bind once" do
    state =
      state(fn s -> {0, s * s} end)
      ~>> fn x ->
        state(fn s ->
          assert x == 0 and s == 16
          {42, s * 2}
        end)
      end

    assert runState(state).(4) == {42, 32}
  end

  test "bind once with return" do
    state =
      return(1)
      ~>> fn x ->
        assert x == 1
        return(x)
      end

    assert runState(state).(42) == {1, 42}
  end

  test "bind once with return and a change" do
    state =
      return(1)
      ~>> fn x ->
        assert x == 1
        return(24)
      end

    assert runState(state).(42) == {24, 42}
  end

  test "bind twice" do
    state =
      state(fn s -> {10, s * s} end)
      ~>> fn x ->
        state(fn s ->
          assert x == 10 and s == 16
          {x * 2, 12}
        end)
      end
      ~>> fn x -> return(x - 1) end

    assert runState(state).(4) == {19, 12}
  end
end
