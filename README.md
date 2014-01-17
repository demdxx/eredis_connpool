Erlang Redis Client Pool for eredis

    dependents: git://github.com/wooga/eredis.git

Examples
========

```erlang
% configure redis
application:start(eredis),
application:set_env(eredis_connpool, pools,
  [ {default, []} ]
),
application:start(eredis_connpool).
```

```erlang
{ok, <<"OK">>} = eredisq:set("foo", "bar").
{ok, <<"bar">>} = eredisq:get("foo").

{ok, <<"OK">>} = eredisq:mset(["foo", "bar", "foo2", "bar2"])).
{ok, [<<"bar">>, <<"bar2">>]} = eredisq:mget(["foo", "foo2"])).

{ok, <<"OK">>} = eredisq:trasaction(fun(_C) ->
  [["SET", "foo", "bar"]]
end).
```
