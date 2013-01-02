%% Copyright (c) 2013 Dmitry Ponomarev
%% Distributed under the MIT license; see LICENSE for details.
-module(eredisq).

-compile(export_all).

q(Name, Q) ->
  {ok, C} = eredis_connpool:connect(Name),
  eredis:q(C, Q).

q(Q) -> q(default, Q).

qp(Name, Q) ->
  {ok, C} = eredis_connpool:connect(Name),
  eredis:qp(C, Q).

qp(Q) -> qp(default, Q).

set(Name, Key, Value) ->
  {ok, C} = eredis_connpool:connect(Name),
  eredis:q(C, ["SET", Key, Value]).

set(Key, Value) -> set(default, Key, Value).

get(Name, Key) ->
  {ok, C} = eredis_connpool:connect(Name),
  eredis:q(C, ["GET", Key]).

get(Key) -> get(default, Key).

mset(Name, Data) ->
  {ok, C} = eredis_connpool:connect(Name),
  eredis:q(C, ["MSET" | Data]).

mset(Data) -> mset(default, Data).

mget(Name, Keys) ->
  {ok, C} = eredis_connpool:connect(Name),
  eredis:q(C, ["MGET" | Keys]).

mget(Keys) -> mget(default, Keys).

transact(Name, F) ->
  {ok, C} = eredis_connpool:connect(Name),
  {ok, <<"OK">>} = eredis:q(C, ["MULTI"]),
  case F(C) of
    {ok, Q} ->
      eredis:qp(C, Q),
      eredis:q(C, ["EXEC"]);
    error ->
      eredis:q(C, ["DISCARD"]);
    _ ->
      eredis:q(C, ["EXEC"])
  end.

transact(F) -> transact(default, F).
