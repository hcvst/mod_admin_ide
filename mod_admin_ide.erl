%% @author Hans Christian v. Stockhausen <hc@vst.io>
%% @copyright 2013 Hans Christian v. Stockhausen

-module(mod_admin_ide).
-author("Hans Christian von Stockhausen <hc@vst.io>").

-mod_title("Admin IDE").
-mod_description("Support editing of site files.").
-mod_prio(1000).
-mod_depends([admin]).
-mod_provides([admin_ide]).

-export([
	     init/1,
         observe_admin_menu/3
]).

-include_lib("zotonic.hrl").
-include_lib("modules/mod_admin/include/admin_menu.hrl").

init(Context) ->
    case m_config:get_value(?MODULE, home_directory, Context) of
    	undefined -> m_config:set_value(?MODULE, home_directory, 
    		z_path:site_dir(Context), Context);
    	_ -> ok
    end.

observe_admin_menu(admin_menu, Acc, Context) ->
    [
     #menu_item{id=admin_ide,
                parent=admin_modules,
                label=?__("IDE", Context),
                url={admin_ide},
                visiblecheck={acl, use, ?MODULE}}
     |Acc].
