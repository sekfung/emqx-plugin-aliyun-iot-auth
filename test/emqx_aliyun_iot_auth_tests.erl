%%%-------------------------------------------------------------------
%%% @author sekfung
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Sep 2020 15:52
%%%-------------------------------------------------------------------
-module(emqx_aliyun_iot_auth_tests).
-author("sekfung").


-include_lib("eunit/include/eunit.hrl").
-import(emqx_auth_aliyun_iot_util, [gen_password/3]).

-define(Setup, fun() -> eredis_cluster:start() end).
-define(Clearnup, fun(_) -> eredis_cluster:stop() end).

%%-define(Setup, fun() -> erlang:display("") end).
%%-define(Clearnup, fun(_) -> erlang:display("") end).

basic_test_() ->
  {inorder,
    {setup, ?Setup, ?Clearnup,
      [
        {"gen pawword",
          fun() ->
            Result = emqx_auth_aliyun_iot_util:gen_password("1912426236|securemode=3,timestamp=1072916711,signmethod=hmacsha1|", "test1&a1U4pQzrgim", "fc73ae4f1f2fb21073f1eee685cf4435"),
            erlang:display(Result),
            ?assertEqual("922ef355d702a63adca62b9b8c1c5f6d59dcd349", Result)
          end
        },

        {"get and set",
          fun() ->
            ?assertEqual({ok, <<"OK">>}, eredis_cluster:q(["SET", "key", "value"])),
            ?assertEqual({ok, <<"value">>}, eredis_cluster:q(["GET", "key"])),
            ?assertEqual({ok, undefined}, eredis_cluster:q(["GET", "nonexists"]))
          end
        },
        {"query device secret in redis cluster mode",
          fun() ->
            ?assertEqual({ok,<<"fc73ae4f1f2fb21073f1eee685cf4435">>}, eredis_cluster:q(["hget", "mqtt_user:test1&a1U4pQzrgim", "device_secret"]))
          end
        }
      ]}
  }
.

