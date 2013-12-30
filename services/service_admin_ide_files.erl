-module(service_admin_ide_files).
-author("Hans Christian von Stockhausen <hc@vst.io>").

-svc_title("Service to list, edit and delete site files.").
-svc_needauth(true).

-export([
	process_get/2,
	process_post/2
	]).

-include_lib("zotonic.hrl").


process_get(_ReqData, Context) ->
    true = z_acl:is_allowed(use, mod_admin_ide, Context),
    {array, walk_directory_tree(z_path:site_dir(Context))}.

process_post(_ReqData, Context) ->
    true = z_acl:is_allowed(use, mod_admin_ide, Context),
    ok.

%%% Internal helper

walk_directory_tree(Path) ->
    [{struct, 
        [
            {id, X},
            {label, filename:basename(X)},
            {children, {array, walk_directory_tree(X ++ "/*")}}
        ]
    } 
    || X <- sorted_directory_entries(Path), 
       string:chr(filename:basename(X), $.) =/= 1 % skip dot files and folders
    ].

sorted_directory_entries(Path) ->
    lists:sort(fun(A, B) -> 
        IsADir = filelib:is_dir(A),
        IsBDir = filelib:is_dir(B),
        (IsADir and not IsBDir) or (IsADir =:= IsBDir and (A < B))
        end
    	,filelib:wildcard(Path)).
