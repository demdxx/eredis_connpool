-module(suite).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").

getset_test_() ->
  eredis_connpool:start_link(default),
  ?assertMatch({ok, <<"OK">>}, eredisq:set("foo", "bar")),
  ?assertMatch({ok, <<"bar">>}, eredisq:get("foo")).

mgetmset_test() ->
  eredis_connpool:start_link(default),
  ?assertMatch({ok, <<"OK">>}, eredisq:mset(["foo", "bar", "foo2", "bar2"])),
  ?assertMatch({ok, [<<"bar">>, <<"bar2">>]}, eredisq:mget(["foo", "foo2"])).

transaction_test() ->
  eredis_connpool:start_link(default),
  ?assertMatch({ok, <<"OK">>}, eredisq:trasaction(fun(_C) ->
    [["SET", "foo", "bar"]]
  end)).


