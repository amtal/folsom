%%%
%%% Copyright 2011, Boundary
%%%
%%% Licensed under the Apache License, Version 2.0 (the "License");
%%% you may not use this file except in compliance with the License.
%%% You may obtain a copy of the License at
%%%
%%%     http://www.apache.org/licenses/LICENSE-2.0
%%%
%%% Unless required by applicable law or agreed to in writing, software
%%% distributed under the License is distributed on an "AS IS" BASIS,
%%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%%% See the License for the specific language governing permissions and
%%% limitations under the License.
%%%


%%%-------------------------------------------------------------------
%%% File:      folsom.erl
%%% @author    joe williams <j@boundary.com>
%%% @doc
%%% @end
%%%------------------------------------------------------------------

-module(folsom).
-export([start/0, start_link/0, stop/0]).

-export([go/0]).

go() -> 
    start(),
    folsom_metrics:new_histogram(foo,exdec),
    {_,S,_} = now(),
    [spawn_link(fun()->faucet(0,S) end)||_<-lists:seq(1,10)].

faucet(N,S0) ->
    gen_event:sync_notify(folsom_event_manager,{foo,1}),
    case now() of
        {_,S0,_} -> faucet(N+1,S0);
        {_,Sn,_} -> 
            io:format("~p~n", [N]),
            faucet(0,Sn)
    end.
    

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.

%% @spec start_link() -> {ok,Pid::pid()}
%% @doc Starts the app for inclusion in a supervisor tree
start_link() -> folsom_sup:start_link().

%% @spec start() -> ok
%% @doc Start the folsom server.
start() -> application:start(folsom).

%% @spec stop() -> ok
%% @doc Stop the folsom server.
stop() -> application:stop(folsom).
