%%--------------------------------------------------------------------
%% Copyright (c) 2020 EMQ Technologies Co., Ltd. All Rights Reserved.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%--------------------------------------------------------------------

-module(emqx_auth_aliyun_iot).

-include_lib("emqx/include/emqx.hrl").
-include_lib("emqx/include/logger.hrl").
-include("../include/emqx_aliyun_iot_auth.hrl").

-export([register_metrics/0
  , load/1
  , unload/0
  , on_client_authenticate/3,
  description/0
]).

-spec(register_metrics() -> ok).
register_metrics() ->
  lists:foreach(fun emqx_metrics:ensure/1, ?AUTH_METRICS).


%% Called when the plugin application start
load(Env) ->
  emqx:hook('client.authenticate', {?MODULE, on_client_authenticate, [Env]}).



on_client_authenticate(ClientInfo = #{clientid := ClientId, username := Username, password := Password}, AuthResult,
    #{auth_cmd := AuthCmd,
      super_cmd := SuperCmd,
      hash_type := HashType,
      timeout := Timeout,
      type := Type,
      pool := Pool}) ->
  io:format("Client(~s, ~s, ~s, ~s) authenticate, Result:~n~p~n", [ClientId, Username, Password, HashType, AuthResult]),
  CheckPass = case emqx_aliyun_iot_auth_cli:q(Pool, Type, AuthCmd, ClientInfo, Timeout) of
                {ok, DeviceSecret} when is_binary(DeviceSecret) ->
                  check_pass(DeviceSecret, ClientInfo);
                {ok, [undefined | _]} ->
                  {error, not_found};
                {ok, [DeviceSecret]} ->
                  check_pass(DeviceSecret, ClientInfo);
                {error, Reason} ->
                  ?LOG(error, "[Redis] Command: ~p failed: ~p", [AuthCmd, Reason]),
                  {error, not_found}
              end,
  case CheckPass of
    ok ->
      ok = emqx_metrics:inc(?AUTH_METRICS(success)),
      IsSuperuser = is_superuser(Pool, Type, SuperCmd, ClientInfo, Timeout),
      {stop, AuthResult#{is_superuser => IsSuperuser,
        anonymous => false,
        auth_result => success}};
    {error, not_found} ->
      ok = emqx_metrics:inc(?AUTH_METRICS(ignore));
    {error, ResultCode} ->
      ok = emqx_metrics:inc(?AUTH_METRICS(failure)),
      ?LOG(error, "[Redis] Auth from redis failed: ~p", [ResultCode]),
      {stop, AuthResult#{auth_result => ResultCode, anonymous => false}}
  end.


%% Called when the plugin application stop
unload() ->
  emqx:unhook('client.authenticate', {?MODULE, on_client_authenticate}).


-spec(is_superuser(atom(), atom(), undefined|list(), emqx_types:client(), timeout()) -> boolean()).
is_superuser(_Pool, _Type, undefined, _ClientInfo, _Timeout) -> false;
is_superuser(Pool, Type, SuperCmd, ClientInfo, Timeout) ->
  case emqx_aliyun_iot_auth_cli:q(Pool, Type, SuperCmd, ClientInfo, Timeout) of
    {ok, undefined} -> false;
    {ok, <<"1">>} -> true;
    {ok, _Other} -> false;
    {error, _Error} -> false
  end.

check_pass(DeviceSecret, #{clientid := ClientId, username := Username, password := Password}) ->
  erlang:display(DeviceSecret),
  erlang:display(ClientId),
  PasswordResult = emqx_aliyun_iot_auth:gen_password(ClientId, Username, Username, ClientId, DeviceSecret),
  case string:equal(PasswordResult, Password) of
    true -> ok;
    false -> ok
  end.



description() -> "EMQ X Authentication Plugin For Aliyun IoT".