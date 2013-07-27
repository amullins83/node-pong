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
    console.log($element.attr("class"));
    handleName = "on" + eventName[0].toUpperCase() + eventName.slice(1);
    onFn = $scope.$eval($attrs[handleName]);
    functionName = $attrs[handleName];
    console.log("" + handleName + " calls " + functionName + ", which is:");
    console.dir(onFn);
    allowedKeys = $scope.$eval($attrs.keys);
    console.log(allowedKeys);
    return $element.bind(eventName, function(evt) {
      var validKey;
      console.log("Detected key event");
      validKey = true;
      if ((allowedKeys != null) && (allowedKeys.length != null)) {
        validKey = false;
        angular.forEach(allowedKeys, function(key) {
          if (key === evt.which) {
            return validKey = true;
          }
        });
      }
      if (validKey) {
        console.log("Key changed state!");
        return $scope.$apply(function() {
          return onFn.call($scope, evt.which);
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
