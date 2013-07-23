(function() {
  'use strict';
  angular.module('nodePong.filters', []).filter('interpolate', [
    'version', function(version) {
      return function(text) {
        return String(text).replace(/\%VERSION\%/mg, version);
      };
    }
  ]).filter('wordCount', function() {
    return function(text) {
      var count;
      count = String(text).split(" ").length;
      if ((text == null) || text.length === 0) {
        return 0;
      } else {
        return count;
      }
    };
  });

}).call(this);
