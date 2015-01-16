defmodule Result.Test do
  use ExUnit.Case, async: true
  use Monad.Operators
  use Monad.Result
  use Curry

  test "bind" do
    assert success(42) ~>> &(&1) == 42
    assert success(42) ~>> &(&1 * 2) == 84
    assert success(42) ~>> &(&1 * &1) == 1764
  end

  test "flat_map one" do
    assert (&(&1)) <|> success(42) |> unwrap! == 42
  end

  test "flat_map two" do
    assert curry(&(&1 + &2)) <|> success(42) <~> success(100) |> unwrap! == 142
  end

  test "flat_map three" do
    assert curry(&(&1 + &2 + &3))
    <|> success(42)
    <~> success(100)
    <~> success(1000)
    |> unwrap! == 1142
  end

  test "flat_map fail first" do
    assert curry(&(&1 + &2 + &3))
           <|> error("oops")
           <~> success(100)
           <~> success(1000)
           |> error?
  end

  test "flat_map fail second" do
    assert curry(&(&1 + &2 + &3))
           <|> success(42)
           <~> error("oops")
           <~> success(1000)
           |> error?
  end

  test "flat_map fail last" do
    assert curry(&(&1 + &2 + &3))
           <|> success(42)
           <~> success(100)
           <~> error("oops")
           |> error?
  end

  test "apply some" do
    assert success(&(&1 * 2)) <~> success(42) |> unwrap! == 84
  end

  test "apply error" do
    assert success(&(&1 * 2)) <~> error("oops") |> error?
  end

  test "apply error fun" do
    assert error("oops") <~> success(42) |> error?
  end
end
