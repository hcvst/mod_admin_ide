angular.module('IDE', ['ngResource', 'ui.ace', 'angularTreeview'])

.factory('FileService', function($resource){
	return $resource('/api/admin_ide/files', null, {
	  list: {method:'GET'}
    })
})

.controller('ideCtrl', function($scope, FileService){
	var selectedFile;

	$scope.directoryTree = FileService.query();

	$scope.$watch('fileBrowser.currentNode', function(newNode, oldNode){
		if(isLeafNode(newNode)){
			var filename = newNode.id;
			console.log("Loading :" + filename);
			selectedFile = FileService.get({filename: filename}, 
				function(){
				    $scope.editor = selectedFile.contents;
			    },
			    function(){
			    	$scope.editor = "Not supported " + filename + ".";
			    	selectedFile = undefined;
			    });
		}
	});

    $scope.isButtonSaveDisabled = function(){
    	return selectedFile === undefined || $scope.editorForm.$pristine;
    };

	$scope.onButtonSaveClicked = function(){
		if(selectedFile){
			selectedFile.contents = $scope.editor;
			selectedFile.$save(function(){
				$scope.editorForm.$setPristine(true);
			}, function(){
				alert("File could not be saved!");
			});
		}
	};

	var isLeafNode = function(node){
		return node !== undefined 
		    && node.children !== undefined
		    && node.children.length == 0;
	}
});