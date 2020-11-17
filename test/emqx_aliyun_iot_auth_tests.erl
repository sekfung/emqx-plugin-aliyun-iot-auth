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


gen_password_test() ->
  Result = emqx_auth_aliyun_iot_util:gen_password("11111|securemode=3,timestamp=2524608000000,signmethod=hmacsha1|", "test1&a1U4pQzrgim", "fc73ae4f1f2fb21073f1eee685cf4435"),
  ?assertEqual("88794a49fc0663f9eb3eb3c97194d2f76d10329b", Result).

