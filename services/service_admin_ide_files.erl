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
    case z_context:get_q(filename, Context) of
        undefined -> {array, walk_directory_tree(z_path:site_dir(Context))};
        Filename -> 
            case is_valid_filename(Filename, Context) of
                true -> {ok, Data} = file:read_file(Filename),
                        {struct, [
                          {filename, Filename},
                          {contents, Data}
                        ]};
                false -> "You cannot access this location."
            end
    end.
    

process_post(ReqData, Context) ->
    true = z_acl:is_allowed(use, mod_admin_ide, Context),
    {Body, _} = wrq:req_body(ReqData),
    Parsed = z_json:from_mochijson(mochijson:binary_decode(Body), Context),
    Filename = binary:bin_to_list(proplists:get_value(<<"filename">>, Parsed)),
    Contents = proplists:get_value(<<"contents">>, Parsed),
    true = is_valid_filename(Filename, Context),
    file:write_file(Filename, Contents).

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

is_valid_filename(Filename, Context) ->
    SiteDir = z_path:site_dir(Context),
    (string:str(Filename, SiteDir) =:= 1) and (string:str(Filename, "..") =:= 0).
