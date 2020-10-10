%%%-------------------------------------------------------------------
%%% @author sekfung
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Sep 2020 13:48
%%%-------------------------------------------------------------------
-module(emqx_auth_aliyun_iot_util).
-author("sekfung").


%% API
-export([gen_password/3]).


gen_password(ClientId, UserName, DeviceSecret) ->
  ClientIdResult = string:tokens(ClientId, "|"),
  IMEI = lists:nth(1, ClientIdResult),
  DeviceNameAndProductKeyResult = string:tokens(UserName, "&"),
  DeviceName = lists:nth(1, DeviceNameAndProductKeyResult),
  ProductKey = lists:nth(2, DeviceNameAndProductKeyResult),
  TimeStampResult = lists:nth(2, string:tokens(lists:nth(2, ClientIdResult), ",")),
  TimeStamp = lists:nth(2, string:tokens(TimeStampResult, "=")),
  WaitingSign = io_lib:format("clientId~sdeviceName~sproductKey~stimestamp~s", [IMEI, DeviceName, ProductKey, TimeStamp]),
  <<Mac:160/integer>> = crypto:hmac(sha, list_to_binary(DeviceSecret), list_to_binary(WaitingSign)),
  lists:flatten(integer_to_list(Mac, 16)).




