defmodule Maybe.Test do
  use ExUnit.Case, async: true
  use Monad.Operators
  import Curry
  import Monad.Maybe

  doctest Monad.Maybe

  test "functor identity" do
    assert Functor.Law.identity?(some 42)
  end

  test "functor composition" do
    assert Functor.Law.composition?(some(10), &(&1 * 2), &(&1 * &1))
  end

  test "applicative identity" do
    assert Applicative.Law.identity? some(42), &return/1
  end

  test "applicative composition" do
    assert Applicative.Law.composition? some(& &1 * 2), some(& &1 * 3), some(& &1 + 2), 42, &return/1
  end

  test "applicative homomorphism" do
    assert Applicative.Law.homomorphism? (& &1 * 2), 42, &return/1
  end

  test "applicative interchange" do
    assert Applicative.Law.interchange? some(& &1 * 2), 42, &return/1
  end

  test "monad left identity law" do
    fun = &(some(&1 * 2))
    assert Monad.Law.left_identity?(42, &return/1, fun)
  end

  test "monad right identity law" do
    assert Monad.Law.right_identity?(some(42), &return/1)
  end

  test "monad associativity law" do
    fun1 = &(some(&1 * 2))
    fun2 = &(some(&1 + 3))
    assert Monad.Law.associativity?(some(42), fun1, fun2)
  end

  test "fmap" do
    assert (& &1) <|> some(42) |> unwrap! == 42
  end

  test "apply two" do
    assert curry(&(&1 + &2)) <|> some(42) <~> some(100) |> unwrap! == 142
  end

  test "apply three" do
    assert curry(&(&1 + &2 + &3))
           <|> some(42)
           <~> some(100)
           <~> some(1000)
           |> unwrap! == 1142
  end

  test "apply fail first" do
    assert curry(&(&1 + &2 + &3)) <|> none <~> some(100) <~> some(1000) |> none?
  end

  test "apply fail second" do
    assert curry(&(&1 + &2 + &3)) <|> some(42) <~> none <~> some(1000) |> none?
  end

  test "apply fail last" do
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

  test "bind" do
    assert some(42) ~>> &(some &1) |> unwrap! == 42
    assert some(42) ~>> &(some &1 * 2) |> unwrap! == 84
    assert some(42) ~>> &(some &1 * &1) |> unwrap! == 1764
  end
end
