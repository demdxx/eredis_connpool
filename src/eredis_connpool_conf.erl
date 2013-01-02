%% Copyright (c) 2013 Dmitry Ponomarev
%% Distributed under the MIT license; see LICENSE for details.
-module(eredis_connpool_conf).

-compile(export_all).

-include("../include/eredis_connpool.hrl").

-spec pools() -> [{pool_name(), list()}].
pools() ->
  case application:get_env(eredis_connpool, pools) of
    undefined -> [{default, []}];
    {ok, L}   -> L
  end.

-spec by_name(atom()) -> {ok, tuple()} | {error, not_found}.
by_name(Name) ->
  by_name(Name, pools()).

-spec by_name(atom(), list()) -> {ok, tuple()} | {error, not_found}.
by_name(Name, Confs) ->
  case proplists:get_value(Name, Confs) of
    undefined ->
      {error, not_found};
    V ->
      {ok, V}
  end.
