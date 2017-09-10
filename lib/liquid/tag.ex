defmodule Liquid.Tag do
  defstruct name: nil, markup: nil, parts: [], attributes: [], blank: false

  def create(markup) when is_binary(markup) do
    destructure [name, rest], String.split(markup, " ", parts: 2)
    %Liquid.Tag{name: name |> String.to_atom, markup: rest}
  end

  def create({name, rest}) do
    %Liquid.Tag{name: name |> to_string |> String.to_atom, markup: rest}
  end

  def create(nil), do: nil
end
