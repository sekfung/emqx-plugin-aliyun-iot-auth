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

-module(emqx_plugin_aliyun_iot_auth).

-include_lib("emqx/include/emqx.hrl").

-export([ load/1
        , unload/0
        ]).

%% Client Lifecircle Hooks
-export([
        on_client_authenticate/3,
        description/0
        ]).

%% Called when the plugin application start
load(Env) ->
    emqx:hook('client.authenticate', {?MODULE, on_client_authenticate, [Env]}).



on_client_authenticate(_ClientInfo = #{clientid := ClientId, username := Username, password := Password}, Result, _Env) ->
    io:format("Client(~s, ~s, ~s) authenticate, Result:~n~p~n", [ClientId, Username, Password, Result]),
    {ok, Result}.



%% Called when the plugin application stop
unload() ->
    emqx:unhook('client.authenticate', {?MODULE, on_client_authenticate}).


description() -> "EMQ X Authentication Plugin For Aliyun IoT".