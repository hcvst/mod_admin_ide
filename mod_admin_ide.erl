%% @author Marc Worrell <marc@worrell.nl>
%% @copyright 2009-2011 Marc Worrell
%% @doc Module for editing and managing categories.

%% Copyright 2009-2011 Marc Worrell
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

-module(mod_admin_ide).
-author("Hans Christian von Stockhausen <hc@vst.io>").

-mod_title("Admin IDE").
-mod_description("Support editing of site files.").
-mod_prio(1000).
-mod_depends([admin]).
-mod_provides([]).

-export([
         observe_admin_menu/3
]).

-include_lib("zotonic.hrl").
-include_lib("modules/mod_admin/include/admin_menu.hrl").

observe_admin_menu(admin_menu, Acc, Context) ->
    [
     #menu_item{id=admin_ide,
                parent=admin_modules,
                label=?__("IDE", Context),
                url={admin_ide},
                visiblecheck={acl, use, ?MODULE}}
     |Acc].
