% module header for helpers
-module(helpers).
-export([get_element/2]).

get_element(Tuple, Index) ->
  case element(Tuple, Index) of
    {ok, Value} -> {ok, Value};
    _ -> {error, nil}
  end.
