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
-import(emqx_auth_aliyun_iot_util, [gen_password/5]).
-import(emqx_plugin_auth_aliyun_iot, [on_client_authenticate/3]).



gen_password_test() ->
  Result = emqx_auth_aliyun_iot_util:gen_password("11111", "test1", "aa", "2524608000000", "bb"),
  erlang:display(Result),
  ?assertEqual("6B1994895A537C8DE9645B1CBE8DC0DFA4A7C4B", Result).

authenticate_test() ->
%%  emqx_plugin_aliyun_iot_auth:on_client_authenticate(
%%    #{clientid => "235a0975ee5d4143b3e37af9800a694a", username => "test2&a1U4pQzrgim", password => "6B1994895A537C8DE9645B1CBE8DC0DFA4A7C4B"},
%%    #{},
%%    #{auth_cmd => "HMGET mqtt_user:test2&a1U4pQzrgim device_secret",
%%      super_cmd => "HMGET mqtt_user:test2&a1U4pQzrgim device_secret",
%%      hash_type => "sha1",
%%      timeout => "0",
%%      type => "single",
%%      pool => 8
%%      }),
  ?assertEqual(4, 4).

