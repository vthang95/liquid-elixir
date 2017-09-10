Nonterminals
liquid filters filter args arg variable object elements strings tags parse_string element
cleaned_string maybe_whitespace
.

Terminals
'{{' '}}' '{%' '%}' quoted_string string '|' ':' ',' whitespace
.

Rootsymbol liquid.

liquid -> elements : ['$1'].

elements -> element           : ['$1'].
elements -> element elements  : '$1' ++ '$2'.

element -> object   : ['Elixir.Liquid.Variable':create('$1')].
element -> tags     : ['Elixir.Liquid.Node':create('$1')].
element -> strings  : [{string, '$1'}].

tags -> '{%' maybe_whitespace cleaned_string maybe_whitespace '%}' : {get_name('$3'), get_rest('$3')}.
tags -> '{%' maybe_whitespace cleaned_string maybe_whitespace strings '%}' : {get_name('$3'), get_rest('$3') ++ trim('$5')}.

object -> '{{' '}}' : nil.
object -> '{{' maybe_whitespace variable maybe_whitespace '}}' : {'$3', []}.
object -> '{{' maybe_whitespace variable maybe_whitespace '|' maybe_whitespace filters maybe_whitespace '}}' : {'$3', '$7'}.

filters -> filter : ['$1'].
filters -> filter maybe_whitespace '|' filters : ['$1'|'$4'].

filter -> variable : {'$1', []}.
filter -> variable maybe_whitespace ':' maybe_whitespace args : {'$1','$5'}.

args -> arg maybe_whitespace : ['$1'].
args -> arg maybe_whitespace ',' maybe_whitespace args : ['$1'|'$5'].

arg -> variable : '$1'.

variable -> string : trim(unwrap('$1')).
variable -> quoted_string : trim(unwrap('$1')).

cleaned_string -> string : trim(unwrap('$1')).

strings -> parse_string         : ['$1'].
strings -> parse_string strings : ['$1'|'$2'].

parse_string -> string                : unwrap('$1').
parse_string -> quoted_string         : unwrap('$1').
parse_string -> '|'                   : atom_to_list('|').
parse_string -> ':'                   : atom_to_list(':').
parse_string -> ','                   : atom_to_list(',').
parse_string -> whitespace            : unwrap('$1').

maybe_whitespace -> whitespace : nil.
maybe_whitespace -> '$empty' : nil.

Erlang code.

unwrap({V, _}) -> V;
unwrap({_,_,V}) -> V.
trim(V) -> string:strip(V).
get_name(V) -> hd(string:split(V, " ")).
get_rest(V) -> tl(string:split(V, " ")).
