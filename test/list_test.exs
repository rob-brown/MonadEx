defmodule List.Test do
  use ExUnit.Case, async: true
  use Monad.Operators

  test "monad left identity law" do
    constructor = &([&1])
    fun = &([&1 * 2])
    assert Monad.Law.left_identity?(42, constructor, fun)
  end

  test "monad right identity law" do
    constructor = &([&1])
    assert Monad.Law.right_identity?([42], constructor)
  end

  test "monad associativity law" do
    fun1 = &([&1 * 2])
    fun2 = &([&1 + 3])
    assert Monad.Law.associativity?([42], fun1, fun2)
  end

  test "bind many" do
    assert (["Billy", "Timmy"] ~>> &(["Hello, #{&1}"])) == ["Hello, Billy", "Hello, Timmy"]
  end

  test "bind flatten" do
    assert (["hello"] ~>> &([&1, &1])) == ["hello", "hello"]
  end

  test "bind flatten many" do
    assert (["hello", "goodbye"] ~>> &([&1, &1])) == ["hello", "hello", "goodbye", "goodbye"]
  end

  test "fmap zero" do
    assert (&(&1 * 2)) <|> [] == []
  end

  test "fmap one" do
    assert (&(&1 * 2)) <|> [42] == [84]
  end

  test "fmap two" do
    assert &(&1 * 2) <|> [4, 2] == [8, 4]
  end

  test "fmap three" do
    assert &(&1 * 2) <|> [4, 2, 10] == [8, 4, 20]
  end

  test "apply" do
    assert [&(&1 * 2), &(&1 + 3)] <~> [1, 2, 3] == [2, 4, 6, 4, 5, 6]
  end

  test "apply empty fun" do
    assert [] <~> [1, 2, 3] == []
  end

  test "apply empty value" do
    assert [&(&1 * 2), &(&1 + 3)] <~> [] == []
  end
end
