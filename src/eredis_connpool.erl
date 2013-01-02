%% Copyright (c) 2013 Dmitry Ponomarev
%% Distributed under the MIT license; see LICENSE for details.
-module(eredis_connpool).

-behaviour(gen_server).

-export([start_link/1, init/1, terminate/2]).
-export([connect/1]).
-export([handle_call/3, handle_cast/2, handle_info/2, code_change/3]).

-include("../include/eredis_connpool.hrl").

-spec name(pool_name()) -> list().
name(Name) ->
  list_to_atom(atom_to_list(Name) ++ "_pool").

start_link(Name) ->
  gen_server:start_link({local, name(Name)}, ?MODULE, Name, []).

init(Name) ->
  {ok, {Name}}.

terminate(normal, _State) ->
  ok.

connect(Name) ->
  gen_server:call(name(Name), connect, infinity).

handle_call(connect, _From, {Name} = State) ->
  L = eredis_connpool_conf:pools(),
  case eredis_connpool_conf:by_name(Name, L) of
    {error, _} ->
      {stop, error, State};
    {ok, Conf} ->
      Link = eredis:start_link(Conf),
      St = {connect, Link, Name},
      {reply, Link, St}
  end;
handle_call(connect, _From, {connect, Link, _Name} = State) ->
  {reply, Link, State}.

handle_cast(Msg, _) ->
  exit({unknown_cast, Msg}).

handle_info(Msg, _) ->
  exit({unknown_info, Msg}).

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
