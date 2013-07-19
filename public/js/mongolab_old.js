// This is a module for cloud persistance in mongolab - https://mongolab.com
angular.module('mongolab', ['ngResource']).
    factory('Assignment', function($resource) {
      var Assignment = $resource('https://api.mongolab.com/api/1/databases' +
          '/heroku_app16360834/collections/assignments/:id',
          { apiKey: 'f7baEysVoRkfvjCQV0fI3d4qSsU6Kyol' }
      );

      return Assignment;
    });