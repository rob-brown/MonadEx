defmodule Monad.Result do

  defstruct type: :ok, value: nil, error: nil

  def success(value), do: %Monad.Result{type: :ok, value: value}
  def error(error), do: %Monad.Result{type: :error, error: error}

  def success?(result), do: result.type == :ok
  def error?(result), do: result.type == :error

  defmacro __using__(_) do
    quote do
      import Monad.Result
    end
  end
end

defimpl Context, for: Monad.Result do
  def unwrap!(%Monad.Result{type: :ok, value: value}), do: value
end

defimpl Functor, for: Monad.Result do
  use Monad.Result

  def fmap(result, fun) when is_function(fun, 1) do
    if success? result do
      result |> Context.unwrap! |> fun.() |> success
    else
      result
    end
  end
end

defimpl Applicative, for: Monad.Result do
  use Monad.Result

  def apply(result, result_fun) do
    Monad.bind(result_fun, &(Functor.fmap result, &1))
  end
end

defimpl Monad, for: Monad.Result do
  use Monad.Result

  def bind(result, fun) when is_function(fun, 1) do
    if success? result do
      result |> Context.unwrap! |> fun.()
    else
      result
    end
  end
end
