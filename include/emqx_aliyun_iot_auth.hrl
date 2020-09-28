%%%-------------------------------------------------------------------
%%% @author sekfung
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 9月 2020 10:28 上午
%%%-------------------------------------------------------------------
-author("sekfung").

-define(APP, emqx_plugin_aliyun_iot_auth).

-record(auth_metrics, {
  success = 'client.auth.success',
  failure = 'client.auth.failure',
  ignore = 'client.auth.ignore'
}).

-define(METRICS(Type), tl(tuple_to_list(#Type{}))).
-define(METRICS(Type, K), #Type{}#Type.K).

-define(AUTH_METRICS, ?METRICS(auth_metrics)).
-define(AUTH_METRICS(K), ?METRICS(auth_metrics, K)).
