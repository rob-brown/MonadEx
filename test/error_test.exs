defmodule Error.Test do
  use ExUnit.Case, async: true
  use Monad.Operators
  import Curry
  import Monad.Error

  doctest Monad.Error

  test "functor identity" do
    assert Functor.Law.identity?(ok(42))
  end

  test "functor composition" do
    assert Functor.Law.composition?(ok(10), &(&1 * 2), &(&1 * &1))
  end

  test "applicative identity" do
    assert Applicative.Law.identity?(ok(42), &return/1)
  end

  test "applicative composition" do
    assert Applicative.Law.composition?(
             ok(&(&1 * 2)),
             ok(&(&1 * 3)),
             ok(&(&1 + 2)),
             42,
             &return/1
           )
  end

  test "applicative homomorphism" do
    assert Applicative.Law.homomorphism?(&(&1 * 2), 42, &return/1)
  end

  test "applicative interchange" do
    assert Applicative.Law.interchange?(ok(&(&1 * 2)), 42, &return/1)
  end

  test "monad left identity law" do
    fun = &ok(&1 * 2)
    assert Monad.Law.left_identity?(42, &return/1, fun)
  end

  test "monad right identity law" do
    assert Monad.Law.right_identity?(ok(42), &return/1)
  end

  test "monad associativity law" do
    fun1 = &ok(&1 * 2)
    fun2 = &ok(&1 + 3)
    assert Monad.Law.associativity?(ok(42), fun1, fun2)
  end

  test "fmap" do
    assert (& &1) <|> ok(42) |> unwrap! == 42
  end

  test "apply two" do
    assert curry(&(&1 + &2)) <|> ok(42) <~> ok(100) |> unwrap! == 142
  end

  test "apply three" do
    assert curry(&(&1 + &2 + &3))
           <|> ok(42)
           <~> ok(100)
           <~> ok(1000)
           |> unwrap! == 1142
  end

  test "apply fail first" do
    assert curry(&(&1 + &2 + &3)) <|> error("error") <~> ok(100) <~> ok(1000) |> error?
  end

  test "apply fail second" do
    assert curry(&(&1 + &2 + &3)) <|> ok(42) <~> error("error") <~> ok(1000) |> error?
  end

  test "apply fail last" do
    assert curry(&(&1 + &2 + &3)) <|> ok(42) <~> ok(100) <~> error("error") |> error?
  end

  test "apply some" do
    assert ok(&(&1 * 2)) <~> ok(42) |> unwrap! == 84
  end

  test "apply none" do
    assert ok(&(&1 * 2)) <~> error("error") |> error?
  end

  test "apply none fun" do
    assert error("error") <~> ok(42) |> error?
  end

  test "bind" do
    assert ok(42) ~>> &(ok(&1) |> unwrap! == 42)
    assert ok(42) ~>> &(ok(&1 * 2) |> unwrap! == 84)
    assert ok(42) ~>> &(ok(&1 * &1) |> unwrap! == 1764)
  end
end
