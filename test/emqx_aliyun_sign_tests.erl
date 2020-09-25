%%%-------------------------------------------------------------------
%%% @author sekfung
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Sep 2020 15:52
%%%-------------------------------------------------------------------
-module(emqx_aliyun_sign_tests).
-author("sekfung").


-include_lib("eunit/include/eunit.hrl").
-import(emqx_aliyun_sign, [sign/1]).



sign_test() ->
%%  SignInfo = emqx_aliyun_sign:SignInfo#{}
%%  emqx_aliyun_sign:sign(SignInfo),
  ?assertEqual(4, 4).

