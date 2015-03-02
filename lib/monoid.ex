defprotocol Monoid do
  @moduledoc """
  Monoids have two principle operations: empty/zero and append.

  This protocol
  doesn't have an `empty` function due to the limitations of Elixir protocols.
  I can implement this functionality using Behaviours, but I haven't done so
  yet.
  """

  @doc """
  Takes two `monoid`s and concatenates them.

  All collections, such as lists and strings, are monoids. Many other types are
  monoids too.
  """
  @spec mappend(t, t) :: t
  def mappend(monoid1, monoid2)
end

defimpl Monoid, for: List do
  def mappend(list1, list2), do: list1 ++ list2
end

defimpl Monoid, for: BitString do
  def mappend(string1, string2), do: string1 <> string2
end
