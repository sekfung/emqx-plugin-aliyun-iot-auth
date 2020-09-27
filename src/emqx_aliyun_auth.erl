%%%-------------------------------------------------------------------
%%% @author sekfung
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Sep 2020 13:48
%%%-------------------------------------------------------------------
-module(emqx_aliyun_auth).
-author("sekfung").


%% API
-export([gen_password/5]).


gen_password(ClientId, DeviceName, ProductKey, Timestamp, DeviceSecret) ->
  WaitingSign = io_lib:format("clientId~sdeviceName~sproductKey~stimestamp~s", [ClientId, DeviceName, ProductKey, Timestamp]),
  <<Mac:160/integer>> = crypto:mac(hmac, sha, list_to_binary(DeviceSecret), list_to_binary(WaitingSign)),
  lists:flatten(integer_to_list(Mac, 16)).




