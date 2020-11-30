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

-module(emqx_auth_aliyun_iot_cli).

-behaviour(ecpool_worker).

-include("../include/emqx_auth_aliyun_iot.hrl").

-include_lib("emqx/include/emqx.hrl").
-include_lib("emqx/include/logger.hrl").

-import(proplists, [get_value/2, get_value/3]).

-export([ connect/1
    , q/4
]).

%%--------------------------------------------------------------------
%% Redis Connect/Query
%%--------------------------------------------------------------------

connect(Opts) ->
    Host = get_value(host, Opts),
    PoolSize = get_value(pool, Opts, 8),
    Password = get_value(password, Opts, ""),
    application:set_env(eredis_cluster, pool_size, PoolSize),
    application:set_env(eredis_cluster, password,  Password),
    application:set_env(eredis_cluster, pool_max_overflow, 10),
    application:set_env(eredis_cluster, socket_options, [{send_timeout, 6000}]),
    eredis_cluster:start(),
    case eredis_cluster:connect(Host) of
        {ok, Pid} -> {ok, Pid};
        {error, Reason = {connection_error, _}} ->
            ?LOG(error, "[Redis] Can't connect to Redis server: Connection refused."),
            {error, Reason};
        {error, Reason = {authentication_error, _}} ->
            ?LOG(error, "[Redis] Can't connect to Redis server: Authentication failed."),
            {error, Reason};
        {error, Reason} ->
            ?LOG(error, "[Redis] Can't connect to Redis server: ~p", [Reason]),
            {error, Reason}
    end.

%% Redis Query.
-spec(q(atom(), string(), emqx_types:clientinfo(), timeout())
        -> {ok, undefined | binary() | list()} | {error, atom() | binary()}).
q(Type, CmdStr, ClientInfo, Timeout) ->
    Cmd = string:tokens(replvar(CmdStr, ClientInfo), " "),
    case Type of
        cluster -> eredis_cluster:q(replvar(Cmd, ClientInfo));
        _ -> eredis:q(Cmd, Timeout)
    end.

replvar(Cmd, ClientInfo = #{cn := CN}) ->
    replvar(repl(Cmd, "%C", CN), maps:remove(cn, ClientInfo));
replvar(Cmd, ClientInfo = #{dn := DN}) ->
    replvar(repl(Cmd, "%d", DN), maps:remove(dn, ClientInfo));
replvar(Cmd, ClientInfo = #{clientid := ClientId}) ->
    replvar(repl(Cmd, "%c", ClientId), maps:remove(clientid, ClientInfo));
replvar(Cmd, ClientInfo = #{username := Username}) ->
    replvar(repl(Cmd, "%u", Username), maps:remove(username, ClientInfo));
replvar(Cmd, _) ->
    Cmd.

repl(S, _Var, undefined) ->
    S;
repl(S, Var, Val) ->
    NVal = re:replace(Val, "&", "\\\\&", [global, {return, list}]),
    re:replace(S, Var, NVal, [{return, list}]).

