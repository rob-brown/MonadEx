# MonadEx

## Summary

`MonadEx` introduces monads into Elixir. Monads encapsulate state and control the flow of code. A monad's bind operation is similar, but more powerful, than Elixir's built-in pipelines.

## Usage

### Included Monads

1. Maybe
  - A simple container representing either something or nothing.
2. Result
  - A container representing success or failure.
3. List
  - Lists are naturally monads, and conform to the necessary protocols.
4. Writer
  - Keeps a log in addition to tracking a value. The log may be a string, array, or any other 'Monoid'.
5. Reader
  - Holds a shared, environment state.
6. State
  - Also holds a shared environment state in addition to tracking a value.

### Extending Monads

Monads may easily be extending by one of two ways:

1. Use the provided `Monad.Behaviour`.
  1. Call `use Monad.Behaviour` first in your monad.
  2. Implement `return/1`.
  3. Implement `bind/2`.
2. Conform to the `Monad` protocol. Additionally, you should conform to the `Functor` and `Applicative` protocols.

### Composing Monads

Monads may be combined to make even more useful constructs. For example, you may want to use a state monad in combination with a result monad. The state monad can track a shared environment and the result monad can keep track of the success or failure state.

### Other Useful Monads

`MonadEx` does not contain the following monads, but they may be useful in some situations. These monads and others may be added later.

1. IO
2. Continuation
3. Random number generation
4. Memoization

## Resources for Understanding Monads

* [Functors, Applicatives, and Monads in Pictures](http://adit.io/posts/2013-04-17-functors,_applicatives,_and_monads_in_pictures.html)
* [Three Useful Monads](http://adit.io/posts/2013-06-10-three-useful-monads.html)
* [Functors, Applicative Functors, and Monoids](http://learnyouahaskell.com/functors-applicative-functors-and-monoids)
* [A Fistful of Monads](http://learnyouahaskell.com/a-fistful-of-monads)
* [A Few Monads More](http://learnyouahaskell.com/for-a-few-monads-more)
* [Category Theory for Beginners](http://www.slideshare.net/kenbot/category-theory-for-beginners)
* [Functional Programming Patterns](http://www.slideshare.net/ScottWlaschin/fp-patterns-buildstufflt)
* [Haskell Docs](https://wiki.haskell.org/Monad)
* [Wikipedia](https://en.wikipedia.org/wiki/Monad_(functional_programming))

## Troubleshooting

Many of the problems that arise with monads is first not understanding functors,
applicatives, and monads. See the listed resources for learning more about
these concepts.

Another gotcha to watch out for is omitting parentheses. Omitting unnecessary
parentheses is a great feature; however, just like Elixir's built-in pipelines,
forgetting parentheses can create ambiguity and unexpected results. For example,
the following (contrived) code is ambiguous:

    monad
    ~>> transform flag
    ~>> process :all

It should instead be replaced with:

    monad
    ~>> transform(flag)
    ~>> process(:all)

## Contributing

Code contributions are welcomed. In order to maintain the integrity of the
project, all pull requests must contain documentation and unit tests. See the
existing tests and documentation for examples. Some easy ideas to contribute is
to add more types of monads.

## License

`MonadEx` is licensed under the MIT license, which is reproduced in its entirety here:

>Copyright (c) 2015–2016 Robert Brown
>
>Permission is hereby granted, free of charge, to any person obtaining a copy
>of this software and associated documentation files (the "Software"), to deal
>in the Software without restriction, including without limitation the rights
>to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>copies of the Software, and to permit persons to whom the Software is
>furnished to do so, subject to the following conditions:
>
>The above copyright notice and this permission notice shall be included in
>all copies or substantial portions of the Software.
>
>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
>OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
>THE SOFTWARE.
