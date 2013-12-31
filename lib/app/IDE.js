angular.module('IDE', ['ngResource', 'ui.ace', 'angularTreeview'])

.factory('FileService', function($resource){
	return $resource('/api/admin_ide/files', null, {
	  list: {method:'GET'}
    })
})

.controller('ideCtrl', function($scope, FileService){
	var selectedFile;

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
				    insertIntoRecentDirectoryTree(newNode);
			    },
			    function(){
			    	$scope.editor = "Not supported " + filename + ".";
			    	selectedFile = undefined;
			    });
		}
	});

	$scope.$watch('recentFileBrowser.currentNode', function(newNode){
		$scope.fileBrowser.selectNodeLabel(newNode);

	});

    $scope.isButtonSaveDisabled = function(){
    	return selectedFile === undefined || $scope.editorForm.$pristine;
    };

	$scope.onButtonSaveClicked = function(){
		save();
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

	var insertIntoRecentDirectoryTree = function(newNode){
		var isNodeAlreadyInserted = false;
        angular.forEach($scope.recentDirectoryTree, function(node){
        	isNodeAlreadyInserted |= node === newNode;
        })
        if(!isNodeAlreadyInserted){
     		$scope.recentDirectoryTree.push(newNode);
	    }

	}
});