-module(service_admin_ide_files).
-author("Hans Christian von Stockhausen <hc@vst.io>").

-svc_title("Service to list, edit and delete site files.").
-svc_needauth(true).

-export([process_get/2]).

-include_lib("zotonic.hrl").


process_get(_ReqData, _Context) ->
    {struct,[{name, "Hans"}, {age, "38"}]}.
