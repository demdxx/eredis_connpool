%% Copyright (c) 2013 Dmitry Ponomarev
%% Distributed under the MIT license; see LICENSE for details.
-module(eredis_connpool_app).

-behaviour(application).
-behaviour(supervisor).

%% supervisor
-export([start_link/0, init/1]).

%% application
-export([start/2, stop/1]).

-export([add_child/1]).

-include("../include/eredis_connpool.hrl").

%% supervisor
start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  Names = [X || {X, _} <- eredis_connpool_conf:pools()],
  Children = [child_spec(Name) || Name <- Names],
  {ok, {{one_for_one, 10, 10}, Children}}.

%% application
start(normal, _Args) ->
  ?MODULE:start_link().

stop(_State) -> ok.

add_child(Name) ->
  supervisor:start_child(?MODULE, child_spec(Name)).

child_spec(Name) ->
  {Name, {eredis_connpool_sup, start_link, [Name]}, permanent,
   16#ffffffff, supervisor, [eredis_connpool_sup]}.
