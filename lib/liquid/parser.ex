defmodule Liquid.Parser do
  @moduledoc """
  specifies the parser API
  """

  @doc """
  Execute a lax parse of markup
  """
  @callback lax(markup :: String.t()) :: any
  @callback lax(block :: %Liquid.Block{}, template :: %Liquid.Template{}) :: any

  @doc """
  Execute a strict parse of markup
  """
  @callback strict(markup :: String.t()) :: any
  @callback strict(block :: %Liquid.Block{}, template :: %Liquid.Template{}) :: any
end
