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

  test "Curry named fun 0" do
    assert curry(&some_fun/0).() == 42
  end

  test "Curry named fun 1" do
    assert curry(&some_fun/1).(1) == 1
  end

  test "Curry named fun 2" do
    assert curry(&some_fun/2).(1).(2) == 3
  end

  test "Curry named fun 3" do
    assert curry(&some_fun/3).(1).(2).(3) == 6
  end

  test "Curry named fun 4" do
    assert curry(&some_fun/4).(1).(2).(3).(4) == 10
  end

  test "Curry named fun 5" do
    assert curry(&some_fun/5).(1).(2).(3).(4).(5) == 15
  end

  test "Curry named fun 6" do
    assert curry(&some_fun/6).(1).(2).(3).(4).(5).(6) == 21
  end

  defp some_fun, do: 42
  defp some_fun(a), do: a
  defp some_fun(a, b), do: a + b
  defp some_fun(a, b, c), do: a + b + c
  defp some_fun(a, b, c, d), do: a + b + c + d
  defp some_fun(a, b, c, d, e), do: a + b + c + d + e
  defp some_fun(a, b, c, d, e, f), do: a + b + c + d + e + f
end
