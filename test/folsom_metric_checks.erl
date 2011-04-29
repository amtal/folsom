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
%%% File:      folsom_metric_checks.erl
%%% @author    amtal <alex.kropivny@gmail.com>
%%% @doc External interface tests.
%%% @end
%%%------------------------------------------------------------------

-module(folsom_metric_checks).

-include_lib("eunit/include/eunit.hrl").

-export([ histograms/0
        ]).

-define(FM, folsom_metrics).
    
histograms() ->
    ok = ?FM:new_histogram(funcalls,uniform),
    5 = ?FM:histogram_timed_update(funcalls, fun()->abs(-5) end),
    5 = ?FM:histogram_timed_update(funcalls, fun(X)->abs(X) end, [-5]),
    5 = ?FM:histogram_timed_update(funcalls, erlang, abs, [-5]),
    [_,_,_] = ?FM:get_histogram_sample(funcalls).
