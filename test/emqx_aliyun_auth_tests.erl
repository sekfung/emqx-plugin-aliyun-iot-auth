%%%-------------------------------------------------------------------
%%% @author sekfung
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Sep 2020 15:52
%%%-------------------------------------------------------------------
-module(emqx_aliyun_auth_tests).
-author("sekfung").


-include_lib("eunit/include/eunit.hrl").
-import(emqx_aliyun_auth, [gen_password/5]).



sign_test() ->
  Result = emqx_aliyun_auth:gen_password("11111", "test1", "aa", "2524608000000", "bb"),
  erlang:display(Result),
  ?assertEqual("6B1994895A537C8DE9645B1CBE8DC0DFA4A7C4B", Result).

