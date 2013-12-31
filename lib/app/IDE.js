angular.module('IDE', ['ngResource', 'ui.ace', 'angularTreeview'])

.factory('FileService', function($resource){
	return $resource('/api/admin_ide/files', null, {
	  list: {method:'GET'}
    })
})

.controller('ideCtrl', function($scope, FileService){
	$scope.directoryTree = FileService.query();

	$scope.$watch('fileBrowser.currentNode', function(newNode, oldNode){
		if(isLeafNode(newNode)){
			var filename = newNode.id;
			console.log("Loading :" + filename);
			var resp = FileService.get({filename: filename}, function(){
				$scope.editor = resp.contents;
			});
		}
	});

	var isLeafNode = function(node){
		return node !== undefined 
		    && node.children !== undefined
		    && node.children.length == 0;
	}
});