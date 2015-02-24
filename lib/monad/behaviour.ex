defmodule Monad.Behaviour do
  use Behaviour

  @type t :: Monad.t
  @type bind_fun :: (term -> t)

  defcallback return(value :: term) :: t
  defcallback bind(monad :: t, fun :: bind_fun) :: t

  def return(module, value), do: module.return(value)

  def bind(module, monad, fun), do: module.bind(monad, fun)

  defmacro __using__(_) do
    quote do
      @behaviour unquote(__MODULE__)

      defimpl Functor, for: __MODULE__ do
        def fmap(monad, fun) do
          return = (& Monad.Behaviour.return @for, &1)
          Monad.Behaviour.bind @for, monad, (& &1 |> fun.() |> return.())
        end
      end

      defimpl Applicative, for: __MODULE__ do
        def apply(monad, monad_fun) do
          Monad.Behaviour.bind @for, monad_fun, (& Functor.fmap monad, &1)
        end
      end

      defimpl Monad, for: __MODULE__ do
        def bind(monad, fun) do
          Monad.Behaviour.bind @for, monad, fun
        end
      end
    end
  end
end
