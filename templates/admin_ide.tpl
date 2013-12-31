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
        <div ng-form="editorForm">
            <div ng-model="editor"
                 ui-ace="{
                useWrapMode : true,
                showGutter: true,
                theme:'tomorrow',
                mode: 'erlang',
                onLoad: aceLoaded,
                onChange: aceChanged
              }">
            </div>
        </div>
    </div>

    <div id="sidebar" class="span4">
        <div class="widget">
            <h3 class="widget-header">IDE</h3>
            <div class="widget-content">
                <div class="btn-group">
                    <button ng-click="onButtonSaveClicked()"
                            ng-disabled="isButtonSaveDisabled()" 
                            type="button" 
                            class="btn btn-primary">
                        Save file
                    </button>
                    <button type="button" class="btn">
                        New file
                    </button>
                    <button type="button" class="btn">
                        New folder
                    </button>
                </div>
            </div>
        </div>

        <div class="widget">
            <h3 class="widget-header">{_ File Browser _}</h3>
            <div class="widget-content">
                <div style="height:320px; overflow:scroll"
                    data-angular-treeview="true"
                    data-tree-id="fileBrowser"
                    data-tree-model="directoryTree"
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