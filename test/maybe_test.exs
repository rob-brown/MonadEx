defmodule Maybe.Test do
  use ExUnit.Case, async: true
  use Monad.Maybe
  use Monad.Operators
  use Curry

  test "left identity law" do
    constructor = &(some &1)
    fun = &(some(&1 * 2))
    assert Monad.Law.left_identity?(42, constructor, fun)
  end

  test "right identity law" do
    constructor = &(some &1)
    assert Monad.Law.right_identity?(some(42), constructor)
  end

  test "associativity law" do
    fun1 = &(some(&1 * 2))
    fun2 = &(some(&1 + 3))
    assert Monad.Law.associativity?(some(42), fun1, fun2)
  end

  test "bind" do
    assert some(42) ~>> &(some &1) |> Context.unwrap! == 42
    assert some(42) ~>> &(some &1 * 2) |> Context.unwrap! == 84
    assert some(42) ~>> &(some &1 * &1) |> Context.unwrap! == 1764
  end

  test "fmap one" do
    assert (&(&1)) <|> some(42) |> Context.unwrap! == 42
  end

  test "fmap two" do
    assert curry(&(&1 + &2)) <|> some(42) <~> some(100) |> Context.unwrap! == 142
  end

  test "fmap three" do
    assert curry(&(&1 + &2 + &3))
           <|> some(42)
           <~> some(100)
           <~> some(1000)
           |> Context.unwrap! == 1142
  end

  test "fmap fail first" do
    assert curry(&(&1 + &2 + &3)) <|> none <~> some(100) <~> some(1000) |> none?
  end

  test "fmap fail second" do
    assert curry(&(&1 + &2 + &3)) <|> some(42) <~> none <~> some(1000) |> none?
  end

  test "fmap fail last" do
    assert curry(&(&1 + &2 + &3)) <|> some(42) <~> some(100) <~> none |> none?
  end

  test "apply some" do
    assert some(&(&1 * 2)) <~> some(42) |> Context.unwrap! == 84
  end

  test "apply none" do
    assert some(&(&1 * 2)) <~> none |> none?
  end

  test "apply none fun" do
    assert none <~> some(42) |> none?
  end
end
