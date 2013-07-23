'use strict';
var AppCtrl, DialogCtrl, GameCtrl, SignInCtrl, TodoCtrl,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

DialogCtrl = (function() {
  function DialogCtrl($scope, $http, $dialog) {
    var _this = this;
    this.$scope = $scope;
    this.$http = $http;
    this.$dialog = $dialog;
    this.$scope.opts = {
      templateUrl: 'modal/signIn',
      controller: SignInCtrl
    };
    this.$scope.openSignIn = function() {
      var d;
      d = _this.$dialog.dialog(_this.$scope.opts);
      return d.open().then(function(result) {
        _this.$scope.didSignIn = result;
        return console.log(result);
      });
    };
  }

  DialogCtrl.$inject = ['$scope', '$http', '$dialog'];

  return DialogCtrl;

})();

AppCtrl = (function() {
  function AppCtrl($scope, $http) {
    this.$scope = $scope;
    this.$http = $http;
    this.getName();
  }

  AppCtrl.prototype.getName = function() {
    var _this = this;
    return this.$http({
      method: 'GET',
      url: '/api/name'
    }).success(function(data, status, headers, config) {
      return _this.$scope.name = data.name;
    }).error(function(data, status, headers, config) {
      return _this.$scope.name = 'Error!';
    });
  };

  AppCtrl.$inject = ['$scope', '$http'];

  return AppCtrl;

})();

GameCtrl = (function() {
  GameCtrl.prototype.width = 600;

  GameCtrl.prototype.height = 400;

  GameCtrl.prototype.fps = 60;

  GameCtrl.prototype.scoreMax = 10;

  GameCtrl.prototype.ballsize = 20;

  GameCtrl.prototype.padHeight = 100;

  GameCtrl.prototype.padWidth = 10;

  GameCtrl.prototype.padOffset = 20;

  function GameCtrl($scope, $http, Game, Pad, Ball, HitDetector) {
    var _this = this;
    this.$scope = $scope;
    this.$http = $http;
    this.redraw = __bind(this.redraw, this);
    this.updatePads = __bind(this.updatePads, this);
    this.updateBall = __bind(this.updateBall, this);
    this.score = __bind(this.score, this);
    this.updateScore = __bind(this.updateScore, this);
    this.update = __bind(this.update, this);
    this.stop = __bind(this.stop, this);
    this.move = __bind(this.move, this);
    $(".popUp").removeClass("shown");
    this.$scope.games = [];
    this.$scope.feedback = [];
    this.$scope.games = Game.query();
    this.$scope.problems = [];
    this.$scope.score = [0, 0];
    this.pad1 = new Pad("pad1", this.padOffset, (this.height - this.padHeight) / 2, this.padWidth, this.padHeight, "w", "s");
    this.pad2 = new Pad("pad2", this.width - this.padWidth - this.padOffset, (this.height - this.padHeight) / 2, this.padWidth, this.padHeight, "up", "down");
    this.pads = [this.pad1, this.pad2];
    this.ball = new Ball((this.width - this.ballsize) / 2, (this.height - this.ballsize) / 2, this.ballsize);
    this.hitDetect = new HitDetector(this.width, this.height);
    this.status = "Running";
    this.updateInterval = setInterval(function() {
      if (_this.status === "Running") {
        return _this.update();
      } else {
        return clearInterval(_this.updateInterval);
      }
    }, 1000 / this.fps);
    $(document).on("keyup", function(evt) {
      return _this.stop(evt.which);
    });
    $(document).on("keydown", function(evt) {
      return _this.move(evt.which);
    });
  }

  GameCtrl.prototype.move = function(key) {
    var pad, _i, _len, _ref, _results;
    _ref = this.pads;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      pad = _ref[_i];
      _results.push(pad.pressKey(key));
    }
    return _results;
  };

  GameCtrl.prototype.stop = function(key) {
    var pad, _i, _len, _ref, _results;
    _ref = this.pads;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      pad = _ref[_i];
      _results.push(pad.releaseKey(key));
    }
    return _results;
  };

  GameCtrl.prototype.update = function() {
    this.updateBall();
    this.updatePads();
    this.updateScore();
    return this.redraw();
  };

  GameCtrl.prototype.updateScore = function() {
    if (this.hitDetect.hitLeftWall(this.ball)) {
      return this.score(1);
    } else if (this.hitDetect.hitRightWall(this.ball)) {
      return this.score(0);
    }
  };

  GameCtrl.prototype.score = function(i) {
    this.$scope.score[i] += 1;
    if (this.$scope.score[i] >= this.scoreMax) {
      this.status = "Player " + (i + 1) + " Wins";
      this.$scope.message = "Player " + (i + 1) + " Wins";
      $(".popUp").text(this.$scope.message);
      $(".popUp").addClass("shown");
    }
    return this.ball = new Ball((this.width - this.ballsize) / 2, (this.height - this.ballsize) / 2, this.ballsize);
  };

  GameCtrl.prototype.updateBall = function() {
    if (this.hitDetect.hit(this.ball, this.pad1) || this.hitDetect.hit(this.ball, this.pad2)) {
      if (this.hitDetect.hitRight(this.ball, this.pad1) || this.hitDetect.hitLeft(this.ball, this.pad2)) {
        this.ball.velocity.x *= -1;
      }
    }
    if (this.hitDetect.hitVertical(this.ball, this.pad1) || this.hitDetect.hitVertical(this.ball, this.pad2) || this.hitDetect.hitVerticalWall(this.ball)) {
      this.ball.velocity.y *= -1;
    }
    this.ball.pos.x += this.ball.velocity.x;
    return this.ball.pos.y += this.ball.velocity.y;
  };

  GameCtrl.prototype.updatePads = function() {
    var pad, _i, _len, _ref, _results;
    _ref = [this.pad1, this.pad2];
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      pad = _ref[_i];
      if (this.hitDetect.hitBottomWall(pad)) {
        _results.push(pad.pos.y = this.height - pad.size.height - 1);
      } else if (this.hitDetect.hitTopWall(pad)) {
        _results.push(pad.pos.y = 1);
      } else {
        _results.push(pad.pos.y += pad.velocity.y);
      }
    }
    return _results;
  };

  GameCtrl.prototype.redraw = function() {
    var index, item, _i, _j, _len, _len1, _ref, _ref1, _results;
    _ref = [this.pad1, this.pad2, this.ball];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      item = _ref[_i];
      $("#" + item.id).css({
        top: item.top()
      });
      $("#" + item.id).css({
        left: item.left()
      });
    }
    _ref1 = [0, 1];
    _results = [];
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      index = _ref1[_j];
      _results.push($("#score" + (index + 1)).text(this.$scope.score[index]));
    }
    return _results;
  };

  GameCtrl.$inject = ['$scope', '$http', 'Game', 'Pad', 'Ball', 'HitDetector'];

  return GameCtrl;

})();

TodoCtrl = (function() {
  function TodoCtrl($scope, $http, Todo) {
    this.$scope = $scope;
    this.$http = $http;
    this.$scope.todos = [];
    this.$scope.todos = Todo.query();
  }

  TodoCtrl.$inject = ['$scope', '$http', 'Todo'];

  return TodoCtrl;

})();

SignInCtrl = (function() {
  function SignInCtrl($scope, $http, User, dialog) {
    var _this = this;
    this.$scope = $scope;
    this.$http = $http;
    this.dialog = dialog;
    this.$scope.user = {};
    this.$scope.close = function(result) {
      return _this.dialog.close(result);
    };
  }

  SignInCtrl.$inject = ['$scope', '$http', 'User', 'dialog'];

  return SignInCtrl;

})();
