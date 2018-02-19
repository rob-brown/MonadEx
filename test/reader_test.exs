defmodule Reader.Test do
  use ExUnit.Case, async: true
  use Monad.Operators
  import Curry
  import Monad.Reader

  doctest Monad.Reader

  test "fmap with no input" do
    reader = (& &1) <|> return(42)
    fun = runReader(reader)
    assert fun.(:bogus) == 42

    reader = (&(&1 * 2)) <|> return(42)
    fun = runReader(reader)
    assert fun.(:bogus) == 84
  end

  test "fmap with input" do
    reader = (& &1) <|> reader(&("Hello, " <> &1))
    fun = runReader(reader)
    assert fun.("World") == "Hello, World"

    reader = (&(&1 <> "!")) <|> reader(&("Hello, " <> &1))
    fun = runReader(reader)
    assert fun.("World") == "Hello, World!"
  end

  test "apply two with no input" do
    reader = curry(&(&1 + &2)) <|> return(4) <~> return(5)
    fun = runReader(reader)
    assert fun.(:bogus) == 9
  end

  test "apply two with input" do
    reader = curry(&(&1 + &2)) <|> reader(&(&1 * 2)) <~> reader(&(&1 * &1))
    fun = runReader(reader)
    assert fun.(2) == 8
    assert fun.(10) == 120
  end

  test "apply three with input" do
    reader =
      curry(&(&1 + &2 + &3))
      <|> reader(&(&1 * 2))
      <~> reader(&(&1 * &1))
      <~> reader(&(&1 - 2))

    fun = runReader(reader)
    assert fun.(2) == 8
    assert fun.(10) == 128
  end

  test "bind once" do
    reader =
      reader(fn _ -> 42 end)
      ~>> fn x ->
        assert x == 42
        return(42)
      end

    assert runReader(reader).(nil) == 42
  end

  test "bind once with input" do
    reader =
      reader(&(&1 * &1))
      ~>> fn x ->
        assert x == 16
        return(x)
      end

    assert runReader(reader).(4) == 16
  end

  test "bind once with return" do
    reader =
      return(42)
      ~>> fn x ->
        assert x == 42
        return(x)
      end

    assert runReader(reader).(nil) == 42
  end

  test "bind twice with input" do
    reader =
      reader(&(&1 * &1))
      ~>> fn x ->
        assert x == 16
        return(x * 2)
      end
      ~>> fn x ->
        assert x == 32
        return(x)
      end

    assert runReader(reader).(4) == 32
  end

  test "bind twice with return" do
    reader =
      return(42)
      ~>> fn x ->
        assert x == 42
        return(x)
      end
      ~>> fn x ->
        assert x == 42
        return(x)
      end

    assert runReader(reader).(nil) == 42
  end

  test "bind twice with return and a change" do
    reader =
      return(42)
      ~>> fn x ->
        assert x == 42
        return(43)
      end
      ~>> fn x ->
        assert x == 43
        return(x)
      end

    assert runReader(reader).(nil) == 43
  end
end
