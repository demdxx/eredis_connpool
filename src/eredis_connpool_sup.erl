%% Copyright (c) 2013 Dmitry Ponomarev
%% Distributed under the MIT license; see LICENSE for details.
-module(eredis_connpool_sup).

-behaviour(supervisor).

%% API
-export([start_link/1]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, P, Type), {I, {I, start_link, P}, permanent, 16#ffffffff, Type, [I]}).

-include("../include/eredis_connpool.hrl").

-spec name(pool_name()) -> list().
name(Name) ->
  list_to_atom(atom_to_list(Name) ++ "_pool_sup").

start_link(Name) ->
  supervisor:start_link({local, name(Name)}, ?MODULE, [Name]).

init([Name]) ->
  Children = [?CHILD(eredis_connpool, [Name], worker)],
  {ok, {{one_for_all, 10, 10}, Children}}.
