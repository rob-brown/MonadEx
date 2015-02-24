defmodule Monad.Result do
  use Monad.Behaviour

  defstruct type: :ok, value: nil, error: nil

  def success(value), do: %Monad.Result{type: :ok, value: value}
  def error(error), do: %Monad.Result{type: :error, error: error}

  def success?(result), do: result.type == :ok
  def error?(result), do: result.type == :error

  def unwrap!(%Monad.Result{type: :ok, value: value}), do: value

  def return(value), do: success value

  def bind(result, fun) when is_function(fun, 1) do
    if success? result do
      result |> unwrap! |> fun.()
    else
      result
    end
  end
end
