defmodule Monad.Test do
  use ExUnit.Case, async: true
  use Monad.Operators
  use Curry

  test "bind" do
    assert 42 ~>> &(&1) == 42
    assert 42 ~>> &(&1 * 2) == 84
    assert 42 ~>> &(&1 * &1) == 1764
  end

  test "flat_map one" do
    assert (&(&1)) <|> 42 == 42
  end

  test "flat_map two" do
    assert curry(&(&1 + &2)) <|> 42 <~> 100 == 142
  end

  test "flat_map three" do
    assert curry(&(&1 + &2 + &3)) <|> 42 <~> 100 <~> 1000 == 1142
  end

  test "flat_map fail first" do
    assert curry(&(&1 + &2 + &3)) <|> nil <~> 100 <~> 1000 == nil
  end

  test "flat_map fail second" do
    assert curry(&(&1 + &2 + &3)) <|> 42 <~> nil <~> 1000 == nil
  end

  test "flat_map fail last" do
    assert curry(&(&1 + &2 + &3)) <|> 42 <~> 100 <~> nil == nil
  end

  test "apply non-nil" do
    assert (&(&1 * 2)) <~> 42 == 84
  end

  test "apply nil" do
    assert (&(&1 * 2)) <~> nil == nil
  end

  test "apply nil fun" do
    assert nil <~> 42 == nil
  end
end
