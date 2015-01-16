defmodule Curry.Test do
  use ExUnit.Case, async: true
  use Curry

  test "Curry 0" do
    assert curry(fn -> 42 end).() == 42
  end

  test "Curry 1" do
    assert curry(&(&1)).(1) == 1
  end

  test "Curry 2" do
    assert curry(&(&1 + &2)).(1).(2) == 3
  end

  test "Curry 3" do
    assert curry(&(&1 + &2 + &3)).(1).(2).(3) == 6
  end

  test "Curry 4" do
    assert curry(&(&1 + &2 + &3 + &4)).(1).(2).(3).(4) == 10
  end

  test "Curry 5" do
    assert curry(&(&1 + &2 + &3 + &4 + &5)).(1).(2).(3).(4).(5) == 15
  end

  test "Curry 6" do
    assert curry(&(&1 + &2 + &3 + &4 + &5 + &6)).(1).(2).(3).(4).(5).(6) == 21
  end
end
