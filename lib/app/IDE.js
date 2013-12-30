angular.module('IDE', ['ngResource', 'ui.ace', 'angularTreeview'])
.factory('FileService', function($resource){
	return $resource('/api/admin_ide/files', null, {
	  list: {method:'GET'}
    })
})
.controller('ideCtrl', function($scope, FileService){
	$scope.treedata = FileService.query();
});