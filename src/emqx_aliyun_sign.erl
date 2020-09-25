%%%-------------------------------------------------------------------
%%% @author sekfung
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Sep 2020 13:48
%%%-------------------------------------------------------------------
-module(emqx_aliyun_sign).
-author("sekfung").


%% API
-export([sign/1]).
-export_type([signInfo/0]).


-type signInfo() ::  #signInfo{}.


-record(signInfo, {productKey = "" :: string(), deviceSecret = "" :: string(), deviceName = "" :: string(), timestamp :: string(), clientId :: string()}).
sign(#signInfo{
  productKey = ProductKey,
  deviceSecret = DeviceSecret,
  deviceName = DeviceName,
  timestamp = Timestamp,
  clientId = ClientId}) -> {
  %%% clientId868523032692875deviceNametest2productKeyg0lkrjpSfzJtimestamp1600931782
  io:format("clientId~sdeviceName~sproductKey~stimestamp~sdeviceSecret~s", [ClientId, DeviceName, ProductKey, Timestamp, DeviceSecret])

}.


