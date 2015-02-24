defmodule Writer.Test do
  use ExUnit.Case, async: true
  use Monad.Operators
  import Monad.Writer

  test "bind once" do
    writer = (writer(42) ~>> (& writer &1, "I did it"))
    assert writer == writer(42, "I did it")
  end

  test "bind twice with string monoid" do
    writer = writer(42)
              ~>> (& writer &1 * 2, "Double")
              ~>> (& writer &1 * 3, "Triple")
    assert writer == writer(252, "DoubleTriple")
  end

  test "bind twice with array monoid" do
    writer = writer(42)
              ~>> (& writer &1 * 2, ["Double"])
              ~>> (& writer &1 * 3, ["Triple"])
    assert writer == writer(252, ["Double", "Triple"])
  end

  # test "fmap one" do
  #   assert (&({&1, "Yay"})) <|> writer(42) == writer(42, "Yay")
  #   assert (&({&1, "Yay"})) <|> writer(42) |> Context.unwrap! == {42, ["Yay"]}
  # end

  # ???: How does apply work with the writer Monad?
end
