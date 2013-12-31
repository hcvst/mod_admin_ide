angular.module('IDE', ['ngResource', 'ui.ace', 'angularTreeview'])

.factory('FileService', function($resource){
	return $resource('/api/admin_ide/files', null, {
	  list: {method:'GET'}
    })
})

.controller('ideCtrl', function($scope, FileService){
	var selectedFile;

    $scope.flagButtonNewFileDisabled = true;
	$scope.flagButtonNewFolderDisabled = true;

	$scope.directoryTree = FileService.query();
	$scope.recentDirectoryTree = [];

	$scope.$watch('fileBrowser.currentNode', function(newNode, oldNode){
		if(newNode === undefined) return;
		if(selectedFile && $scope.editorForm.$dirty && $scope.isAutoSaveEnabled){
			save();
		}
		var isFileNode = !newNode.isDirNode;
		$scope.flagButtonNewFileDisabled = isFileNode;
		$scope.flagButtonNewFolderDisabled = isFileNode;
		if(isFileNode){
			var filename = newNode.id;
			console.log("Loading :" + filename);
			selectedFile = FileService.get({filename: filename}, 
				function(){
				    $scope.editor = selectedFile.contents;
				    $scope.editorForm.$setPristine(true);
				    appendToRecentDirectoryTree(newNode);
			    },
			    function(){
			    	$scope.editor = "Not supported " + filename + ".";
			    	selectedFile = undefined;
			    });
		}
	});

	$scope.$watch('recentFileBrowser.currentNode', function(newNode){
		if(newNode === undefined) return;
		$scope.fileBrowser.selectNodeLabel(newNode);

	});

    $scope.isButtonSaveDisabled = function(){
    	return selectedFile === undefined || $scope.editorForm.$pristine;
    };

	$scope.onButtonSaveClicked = function(){
		save();
	};

	$scope.onButtonNewFileClicked = function(){
		var filename = prompt($scope.fileBrowser.currentNode.id);
		if(!filename) return;
		var filepath = $scope.fileBrowser.currentNode.id + "/" + filename;
		var fileAlreadyExists = false;
		angular.forEach($scope.fileBrowser.currentNode.children, function(node){
			fileAlreadyExists |= filepath == node.id;
		});
		if(fileAlreadyExists){
			alert("File " + filename + " already exists.");
			return;
		}
		newFile = new FileService({filename: filepath, contents:"%% " + filename});
		newFile.$save(function(){
			    var parent = $scope.fileBrowser.currentNode;
			    var newNode = {
			    	id: filepath,
			    	isDirNode: false,
			    	label: filename,
			    	children: []
			    };
			    insertIntoDirectoryTree(parent, newNode);
		    }, function(){
			  alert("Could not create file " + filename + ".");
		});
	};

	$scope.onButtonNewFolderClicked = function(){
		alert("Not implemented!");
	};

	var save = function(){
		if(selectedFile){
			selectedFile.contents = $scope.editor;
			selectedFile.$save(function(){
				$scope.editorForm.$setPristine(true);
			}, function(){
				alert("File could not be saved!");
			});
		}
	};

	var appendToRecentDirectoryTree = function(newNode){
		var isNodeAlreadyInserted = false;
        angular.forEach($scope.recentDirectoryTree, function(node){
        	isNodeAlreadyInserted |= node === newNode;
        })
        if(!isNodeAlreadyInserted){
     		$scope.recentDirectoryTree.push(newNode);
	    }
	};

	var insertIntoDirectoryTree = function(parent, newNode){
		var children = parent.children;
		var insertIdx = 0;
		for(var i=0; i<children.length; i++){
			insertIdx = i;
			var child = children[i];
            if(!child.isDirNode && newNode.label < child.label){
            	break;
            }
		}
		children.splice(insertIdx, 0, newNode);
	};
});
