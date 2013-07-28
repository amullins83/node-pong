'use strict';
var Directives, handle;

Directives = angular.module('nodePong.directives', []);

Directives.directive('appVersion', [
  'version', function(version) {
    return function(scope, elm, attrs) {
      return elm.text(version);
    };
  }
]);

handle = function(eventName) {
  return function($scope, $element, $attrs) {
    var allowedKeys, functionName, handleName, onFn;
    handleName = "on" + eventName[0].toUpperCase() + eventName.slice(1);
    onFn = $scope.$eval($attrs[handleName]);
    functionName = $attrs[handleName];
    allowedKeys = $scope.$eval($attrs.keys);
    return $(document).bind(eventName, function(evt) {
      var validKey;
      validKey = true;
      if ((allowedKeys != null) && (allowedKeys.length != null)) {
        validKey = false;
        angular.forEach(allowedKeys, function(key) {
          if (key === evt.keyCode) {
            return validKey = true;
          }
        });
      }
      if (validKey) {
        return $scope.$apply(function() {
          return onFn.call($scope, evt.keyCode);
        });
      }
    });
  };
};

Directives.directive('onKeyup', function() {
  return handle("keyup");
});

Directives.directive('onKeydown', function() {
  return handle("keydown");
});
