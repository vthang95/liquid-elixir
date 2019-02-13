defmodule Liquid do
  use Application

  def start(_type, _args), do: start()

  def start do
    Liquid.Filters.add_filter_modules()
    Liquid.Supervisor.start_link()
  end

  def stop, do: {:ok, "stopped"}

  def filter_arguments, do: ~r/(?::|,)\s*(#{quoted_fragment()})/
  def single_quote, do: "'"
  def double_quote, do: "\""
  def quote_matcher, do: ~r/#{single_quote()}|#{double_quote()}/

  def variable_start, do: "{{"
  def variable_end, do: "}}"
  def variable_incomplete_end, do: "\}\}?"

  def tag_start, do: "{%"
  def tag_end, do: "%}"

  def any_starting_tag, do: "(){{()|(){%()"

  def invalid_expression,
    do: ~r/^{%.*}}$|^{{.*%}$|^{%.*([^}%]}|[^}%])$|^{{.*([^}%]}|[^}%])$|(^{{|^{%)/ms

  def tokenizer,
    do: ~r/()#{tag_start()}.*?#{tag_end()}()|()#{variable_start()}.*?#{variable_end()}()/

  def parser,
    do:
      ~r/#{tag_start()}\s*(?<tag>.*?)\s*#{tag_end()}|#{variable_start()}\s*(?<variable>.*?)\s*#{
        variable_end()
      }/m

  def template_parser, do: ~r/#{partial_template_parser()}|#{any_starting_tag()}/ms

  def partial_template_parser,
    do: "()#{tag_start()}.*?#{tag_end()}()|()#{variable_start()}.*?#{variable_incomplete_end()}()"

  def quoted_string, do: "\"[^\"]*\"|'[^']*'"
  def quoted_fragment, do: "#{quoted_string()}|(?:[^\s,\|'\"]|#{quoted_string()})+"

  def tag_attributes, do: ~r/(\w+)\s*\:\s*(#{quoted_fragment()})/
  def variable_parser, do: ~r/\[[^\]]+\]|[\w\-]+/
  def filter_parser, do: ~r/(?:\||(?:\s*(?!(?:\|))(?:#{quoted_fragment()}|\S+)\s*)+)/

  defmodule List do
    def even_elements([_, h | t]) do
      [h] ++ even_elements(t)
    end

    def even_elements([]), do: []
  end

  defmodule Atomizer do
    def to_existing_atom(string) do
      try do
        String.to_existing_atom(string)
      rescue
        ArgumentError -> nil
      end
    end
  end
end
