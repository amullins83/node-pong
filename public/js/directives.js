'use strict';
var Directives;

Directives = angular.module('nodePong.directives', []);

Directives.directive('appVersion', [
  'version', function(version) {
    return function(scope, elm, attrs) {
      return elm.text(version);
    };
  }
]);
