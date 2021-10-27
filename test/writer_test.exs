defmodule Writer.Test do
  use ExUnit.Case, async: true
  use Monad.Operators
  import Curry
  import Monad.Writer

  doctest Monad.Writer

  test "fmap" do
    assert (& &1) <|> writer(42) == writer(42)
    assert (& &1) <|> writer(42, "Hello") == writer(42, "Hello")
    assert (& &1) <|> writer(42, "Hello") |> runWriter == {42, "Hello"}
  end

  test "apply one" do
    assert writer(& &1) <~> writer(42) == writer(42)
    assert writer(& &1) <~> writer(42, "Hello") == writer(42, "Hello")
    assert writer(& &1) <~> writer(42, "Hello") |> runWriter == {42, "Hello"}
  end

  test "apply two" do
    assert curry(&(&1 + &2)) <|> writer(4, "Four") <~> writer(5, "Five") == writer(9, "FourFive")

    assert curry(&(&1 + &2)) <|> writer(4, ["Four"]) <~> writer(5, ["Five"]) ==
             writer(9, ["Four", "Five"])
  end

  test "bind once" do
    writer = writer(42) ~>> (&writer(&1, "I did it"))
    assert writer == writer(42, "I did it")
  end

  test "bind twice with string monoid" do
    writer =
      writer(42)
      ~>> (&writer(&1 * 2, "Double"))
      ~>> (&writer(&1 * 3, "Triple"))

    assert writer == writer(252, "DoubleTriple")
  end

  test "bind twice with array monoid" do
    writer =
      writer(42)
      ~>> (&writer(&1 * 2, ["Double"]))
      ~>> (&writer(&1 * 3, ["Triple"]))

    assert writer == writer(252, ["Double", "Triple"])
  end
end
