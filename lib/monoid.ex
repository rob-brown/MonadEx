defprotocol Monoid do
  @spec mappend(t, t) :: t
  def mappend(monoid1, monoid2)
end

# ???: Should I make an operator for Monoid.mappend? Perhaps `++`?

defimpl Monoid, for: List do
  def mappend(list1, list2), do: list1 ++ list2
end

defimpl Monoid, for: BitString do
  def mappend(string1, string2), do: string1 <> string2
end
