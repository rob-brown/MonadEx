defmodule Monad.Test do
  use ExUnit.Case, async: true
  use Monad.Operators
  import Curry

  doctest Monad.Operators
  doctest Monad.Behaviour

  test "bind" do
    assert 42 ~>> &(&1) == 42
    assert 42 ~>> &(&1 * 2) == 84
    assert 42 ~>> &(&1 * &1) == 1764
  end

  test "fmap one" do
    assert (&(&1)) <|> 42 == 42
  end

  test "fmap two" do
    assert curry(&(&1 + &2)) <|> 42 <~> 100 == 142
  end

  test "fmap three" do
    assert curry(&(&1 + &2 + &3)) <|> 42 <~> 100 <~> 1000 == 1142
  end

  test "fmap fail first" do
    assert curry(&(&1 + &2 + &3)) <|> nil <~> 100 <~> 1000 == nil
  end

  test "fmap fail second" do
    assert curry(&(&1 + &2 + &3)) <|> 42 <~> nil <~> 1000 == nil
  end

  test "fmap fail last" do
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
