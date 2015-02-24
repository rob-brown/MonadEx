defmodule Reader.Test do
  use ExUnit.Case, async: true
  use Monad.Operators
  import Monad.Reader

  test "bind once" do
    reader = reader(fn _ -> 42 end)
              ~>> fn x -> assert x == 42; return 42 end
    assert runReader(reader).(nil) == 42
  end

  test "bind once with input" do
    reader = reader(&(&1 * &1))
              ~>> fn x -> assert x == 16; return x end
    assert runReader(reader).(4) == 16
  end

  test "bind once with return" do
    reader = return(42)
              ~>> fn x -> assert x == 42; return x end
    assert runReader(reader).(nil) == 42
  end

  test "bind twice with input" do
    reader = reader(&(&1 * &1))
              ~>> fn x -> assert x == 16; return x * 2 end
              ~>> fn x -> assert x == 32; return x end
    assert runReader(reader).(4) == 32
  end

  test "bind twice with return" do
    reader = return(42)
              ~>> fn x -> assert x == 42; return x end
              ~>> fn x -> assert x == 42; return x end
    assert runReader(reader).(nil) == 42
  end

  test "bind twice with return and a change" do
    reader = return(42)
              ~>> fn x -> assert x == 42; return 43 end
              ~>> fn x -> assert x == 43; return x end
    assert runReader(reader).(nil) == 43
  end
end
