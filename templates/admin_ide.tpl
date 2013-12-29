{% extends "admin_base.tpl" %}

{% block title %}{_ IDE _}{% endblock %}

{% block js_extra %}    
    {% lib
        "bower_components/ace-builds/src-min-noconflict/ace.js" 
        "bower_components/angular/angular.js"
        "bower_components/angular-ui-ace/ui-ace.js"
        "app/IDE.js"
        "IDE.css"
    %}
{% endblock %}

{% block content %}
{% with m.acl.is_admin as editable %}
<div class="edit-header">
    <h2>{_ IDE _}</h2>

    <p>{_ The IDE let's you _}</p>
</div>
<div class="row-fluid">
    <div id="category-sorter" class="span8">
        <div ng-app="IDE" id="ide">
            <div ui-ace="{
                useWrapMode : true,
                showGutter: true,
                theme:'tomorrow',
                mode: 'erlang',
                onLoad: aceLoaded,
                onChange: aceChanged
              }"></div>
        </div>
    </div>

    <div id="sidebar" class="span4">
        <div class="widget">
            <h3 class="widget-header">{_ How does this work??? _}</h3>
            <div class="widget-content">
                <p>
                    Hello IDE
                </p>
            </div>
        </div>
    </div>
</div>
</div>
{% endwith %}
{% endblock %}