defmodule Liquid.ParserSwitching do
  @moduledoc """
  Is responsible for the selection of what error mode the parser will handle

  There are three error modes:
  :strict Raises a SyntaxError when invalid syntax is used
  :warn Adds errors to template.errors but continues as normal
  :lax The default mode, accepts almost anything

  Error mode is loaded Application.get_env
  """

  @error_mode Application.get_env(:ecto, :error_mode, :lax)

  @doc """
  Select the parser based on the error_mode
  """
  def parse_with_selected_parser(markup, parser) do
    case @error_mode do
      :strict -> strict_parse_with_error_context(markup, parser)
      :lax -> parser.lax(markup)
      :warn ->
        try do
          strict_parse_with_error_context(markup, parser)
        rescue
          _ ->
            # TODO: save errors into somewhere
            parser.lax(markup)
        end
    end
  end

  def parse_with_selected_parser(block, template, parser) do
    case @error_mode do
      :strict -> strict_parse_with_error_context(block, template, parser)
      :lax -> parser.lax(block, template)
      :warn ->
        try do
          strict_parse_with_error_context(block, template, parser)
        rescue
          _ ->
            # TODO: save errors into somewhere
            parser.lax(block, template)
        end
    end
  end

  defp strict_parse_with_error_context(_markup, _parser) do
    raise ":strict error mode it is not implemented in this version "
  end

  defp strict_parse_with_error_context(_block, _template, _parser) do
    raise ":strict error mode it is not implemented in this version "
  end
end
