defprotocol Monad do
  @fallback_to_any true

  # Takes a monad value and a function that returns a monad and returns a monad.
  # (>>=) :: m a -> (a -> m b) -> m b
  # (monad<a>, (a -> monad<b>)) -> monad<b>
  @spec bind(t, (term -> t)) :: t
  def bind(value, fun)
end

# TODO: Make reader, writer, and state monads. http://adit.io/posts/2013-06-10-three-useful-monads.html
# https://en.wikipedia.org/wiki/Monad_(functional_programming)#Monad_laws
# http://stackoverflow.com/questions/44965/what-is-a-monad
# TODO: Use a QuickCheck-like algorithm to check that the monads fullfil the Monad laws.
# Should I implement liftM and liftA2?
# ???: Should I make monads into a behaviour?

# Haskell defines Monoids like this:
# class Monoid m where
#   mempty :: m
#   mappend :: m -> m -> m
#   mconcat :: [m] -> m
#   mconcat = foldr mappend mempty
# What is the difference between a monoid and monad?
# The writer can take any monoid. Since monoids can be appended, they work nicely with accumulating data.

defimpl Monad, for: Any do

  def bind(nil, fun) when is_function(fun, 1), do: nil
  def bind(value, fun) when is_function(fun, 1) do
    fun.(value)
  end
end
