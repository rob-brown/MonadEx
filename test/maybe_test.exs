defmodule Maybe.Test do
  use ExUnit.Case, async: true
  use Monad.Maybe
  use Monad.Operators
  use Curry

  test "bind" do
    assert some(42) ~>> &(&1) == 42
    assert some(42) ~>> &(&1 * 2) == 84
    assert some(42) ~>> &(&1 * &1) == 1764
  end

  test "flat_map one" do
    assert (&(&1)) <|> some(42) |> unwrap! == 42
  end

  test "flat_map two" do
    assert curry(&(&1 + &2)) <|> some(42) <~> some(100) |> unwrap! == 142
  end

  test "flat_map three" do
    assert curry(&(&1 + &2 + &3))
           <|> some(42)
           <~> some(100)
           <~> some(1000)
           |> unwrap! == 1142
  end

  test "flat_map fail first" do
    assert curry(&(&1 + &2 + &3)) <|> none <~> some(100) <~> some(1000) |> none?
  end

  test "flat_map fail second" do
    assert curry(&(&1 + &2 + &3)) <|> some(42) <~> none <~> some(1000) |> none?
  end

  test "flat_map fail last" do
    assert curry(&(&1 + &2 + &3)) <|> some(42) <~> some(100) <~> none |> none?
  end

  test "apply some" do
    assert some(&(&1 * 2)) <~> some(42) |> unwrap! == 84
  end

  test "apply none" do
    assert some(&(&1 * 2)) <~> none |> none?
  end

  test "apply none fun" do
    assert none <~> some(42) |> none?
  end
end
