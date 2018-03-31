%%%-------------------------------------------------------------------
%%% @author Kasper
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Mar 2018 12:31
%%%-------------------------------------------------------------------
-module(rpn_calc).
-author("Kasper").

%% API
-export([rpn/1]).

rpn(Expr) ->
  Tokens = tokenize(Expr),
  case lists:any(fun verbosity/1, Tokens) of
    true -> do_verbose(lists:filter(fun(X) -> not verbosity(X) end, Tokens));
    _ -> process(Tokens, [])
  end.

do_verbose(Tokens) ->
  io:format("Input: "),
  print_list(Tokens),
  io:format("Output: "),
  process(Tokens, []).

verbosity(X) ->
  case X of
    "v" -> true;
    "verbose" -> true;
    _ -> false
  end.

tokenize(Expr) ->
  string:tokens(Expr, " ").

process([], []) ->
  0;
process([], [SH | _ST]) ->
  SH;
process(["+" | T], [A, B | ST]) when is_number(A) and is_number(B) ->
  process(T, [A + B | ST]);
process(["-" | T], [A, B | ST]) when is_number(A) and is_number(B) ->
  process(T, [A - B | ST]);
process(["*" | T], [A, B | ST]) when is_number(A) and is_number(B) ->
  process(T, [A * B | ST]);
process(["/" | T], [A, B | ST]) when is_number(A) and is_number(B) ->
  process(T, [B / A | ST]);
process(["pow" | T], [A, B | ST]) when is_number(A) and is_number(B) ->
  process(T, [math:pow(B, A) | ST]);
process(["sqrt" | T], [A | ST]) when is_number(A) ->
  process(T, [math:sqrt(A) | ST]);
process(["sin" | T], [A | ST]) when is_number(A) ->
  process(T, [math:sin(A) | ST]);
process(["cos" | T], [A | ST]) when is_number(A) ->
  process(T, [math:cos(A) | ST]);
process(["tan" | T], [A | ST]) when is_number(A) ->
  process(T, [math:tan(A) | ST]);
process(["cot" | T], [A | ST]) when is_number(A) ->
  process(T, [1 / math:tan(A) | ST]);
process(["ceil" | T], [A | ST]) when is_number(A) ->
  process(T, [1 / math:ceil(A) | ST]);
process(["floor" | T], [A | ST]) when is_number(A) ->
  process(T, [1 / math:floor(A) | ST]);
process(["pop" | T], [_A | ST]) ->
  process(T, ST);
process(["ps" | T], ST) ->
  print_stack(ST),
  process(T, ST);
process([H | T], Stack) ->
  Converted = conv_token(H),
  case Converted of
    error ->
      process(T, Stack);
    _ ->
      process(T, [Converted | Stack])
  end.

%%conv_token(E) ->
%%  case string:to_float(E) of
%%    {error, _Reason} ->
%%      case string:to_integer(E) of
%%        {error, no_integer} -> error;
%%        {Int, []} -> Int
%%      end;
%%    {Float, _Rest} -> Float
%%  end.

conv_token(E) ->
  Float = (catch list_to_float(E)),
  Int = (catch list_to_integer(E)),
  if
    is_float(Float) -> Float;
    is_integer(Int) -> Int;
    true -> error
  end.

print_stack(L) ->
  io:format(">-|"),
  print_st(lists:reverse(L)).

print_st([]) ->
  io:format("|--~n");
print_st([H | T]) ->
  io:format("~w, ", [H]),
  print_st(T).

print_list([]) ->
  io:format("~n");
print_list([H | T]) when is_number(H) ->
  io:format("~w, ", [H]),
  print_list(T);
print_list([H | T]) ->
  io:format("~s, ", [H]),
  print_list(T).

