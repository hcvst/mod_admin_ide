{% extends "admin_base.tpl" %}

{% block title %}{_ IDE _}{% endblock %}

{% block js_extra %}    
    {% lib
        "bower_components/angular/angular.js"
        "bower_components/angular-resource/angular-resource.min.js"

        "bower_components/ace-builds/src-min-noconflict/ace.js" 
        "bower_components/angular-ui-ace/ui-ace.js"

        "treeview/angular.treeview.min.js"
        "treeview/css/angular.treeview.css"

        "app/IDE.js"
        "IDE.css"
    %}
{% endblock %}

{% block content %}
{% with m.acl.is_admin as editable %}
<!-- div class="edit-header">
    <h2>{_ IDE _}</h2>

    <p>{_ The IDE let's you _}</p>
</div -->
<div class="row-fluid" ng-app="IDE" ng-controller="ideCtrl">
    <div id="category-sorter" class="span8">
        <div>
            <div ui-ace="{
                useWrapMode : true,
                showGutter: true,
                theme:'tomorrow',
                mode: 'erlang',
                onLoad: aceLoaded,
                onChange: aceChanged
              }">
%% -*- mode: erlang -*-
[
    {admin_ide, ["admin", "ide"], controller_admin_ide, []}
].
            </div>
        </div>
    </div>

    <div id="sidebar" class="span4">
        <div class="widget">
            <h3 class="widget-header">{_ IDE _}</h3>
            <div class="widget-content">
                <p>
                    Toolbar goes here
                </p>
            </div>
        </div>

        <div class="widget">
            <h3 class="widget-header">{_ File Browser _}</h3>
            <div class="widget-content">
                <div
                    data-angular-treeview="true"
                    data-tree-id="abc"
                    data-tree-model="treedata"
                    data-node-id="id"
                    data-node-label="label"
                    data-node-children="children" >
                </div>
            </div>
        </div>


    </div>
</div>
</div>
{% endwith %}
{% endblock %}