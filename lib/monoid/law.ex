defmodule Monoid.Law do

  def closure?(monoid1, monoid2) when is_list(monoid1) and is_list(monoid2) do
    Monoid.mappend(monoid1, monoid2) |> is_list
  end
  def closure?(monoid1, monoid2) when is_binary(monoid1) and is_binary(monoid2) do
    Monoid.mappend(monoid1, monoid2) |> is_binary
  end
  def closure?(m1, m2) when is_map(m1) and is_map(m2) do
    m3 = Monoid.mappend(m1, m2)
    is_map(m3) and Map.get(m1, :__struct__) == Map.get(m2, :__struct__) and Map.get(m2, :__struct__) == Map.get(m3, :__struct__)
  end
  def closure?(_monoid1, _monoid2) do
    false
  end

  def identity?(monoid, identity) do
    Monoid.mappend(monoid, identity) == monoid and Monoid.mappend(identity, monoid) == monoid
  end

  def associativity?(monoid1, monoid2, monoid3) do
    Monoid.mappend(Monoid.mappend(monoid1, monoid2), monoid3) == Monoid.mappend(monoid1, Monoid.mappend(monoid2, monoid3))
  end
end
