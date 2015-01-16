defmodule Monad.Result do

  defstruct type: :ok, value: nil, error: nil

  def success(value), do: %Monad.Result{type: :ok, value: value}
  def error(error), do: %Monad.Result{type: :error, error: error}

  def unwrap!(%Monad.Result{type: :ok, value: value}), do: value

  def success?(result), do: result.type == :ok
  def error?(result), do: result.type == :error

  defmacro __using__(_) do
    quote do
      import Monad.Result
    end
  end
end

defimpl Monad, for: Monad.Result do
  use Monad.Result

  def bind(result, fun) when is_function(fun, 1) do
    if success? result do
      result |> unwrap! |> fun.()
    else
      result
    end
  end

  def flat_map(result, fun) when is_function(fun, 1) do
    if success? result do
      result |> unwrap! |> fun.() |> success
    else
      result
    end
  end

  def apply(result, result_fun) do
    bind(result_fun, &(flat_map result, &1))
  end
end
