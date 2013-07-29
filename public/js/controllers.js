'use strict';
var AppCtrl, DialogCtrl, GameCtrl, SignInCtrl, TodoCtrl,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

DialogCtrl = (function() {
  function DialogCtrl($scope, $http, $dialog, User) {
    var _base,
      _this = this;
    this.$scope = $scope;
    this.$http = $http;
    this.$dialog = $dialog;
    this.$scope.opts = {
      templateUrl: 'modal/signIn',
      controller: SignInCtrl
    };
    this.$scope.user = User.query()[0];
    this.$scope.logOutText = "Log Out";
    this.$scope.signInText = "Sign In";
    this.$scope.signInOutText = (typeof (_base = this.$scope).user === "function" ? _base.user(this.$scope.logOutText) : void 0) ? void 0 : this.$scope.signInText;
    this.$scope.openSignIn = function() {
      var d;
      d = _this.$dialog.dialog(_this.$scope.opts);
      return d.open().then(function(result) {
        if ((result != null) && (result.email != null)) {
          _this.$scope.didSignIn = true;
          _this.$scope.signInOutText = "Log Out";
          return _this.$scope.user = result;
        }
      });
    };
    this.$scope.logOut = function() {
      return _this.$http["delete"]("./logout").success(function(data, status, headers, config) {
        _this.$scope.signInOutText = "Sign In";
        return _this.$scope.user = null;
      });
    };
    this.$scope.signInOutButton = function() {
      if (_this.$scope.user == null) {
        return _this.$scope.openSignIn();
      } else {
        return _this.$scope.logOut();
      }
    };
  }

  DialogCtrl.$inject = ['$scope', '$http', '$dialog', 'User'];

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

  function GameCtrl($scope, $http, $timeout, Game, Pad, Ball, HitDetector) {
    var _this = this;
    this.$scope = $scope;
    this.$http = $http;
    this.$timeout = $timeout;
    this.redraw = __bind(this.redraw, this);
    this.updatePads = __bind(this.updatePads, this);
    this.updateBall = __bind(this.updateBall, this);
    this.score = __bind(this.score, this);
    this.updateScore = __bind(this.updateScore, this);
    this.update = __bind(this.update, this);
    this.stop = __bind(this.stop, this);
    this.move = __bind(this.move, this);
    this.updateLater = __bind(this.updateLater, this);
    this.$scope.games = [];
    this.$scope.feedback = [];
    this.$scope.problems = [];
    this.$scope.score = [0, 0];
    this.$scope.pad1 = new Pad("pad1", this.padOffset, (this.height - this.padHeight) / 2, this.padWidth, this.padHeight, "w", "s");
    this.$scope.pad2 = new Pad("pad2", this.width - this.padWidth - this.padOffset, (this.height - this.padHeight) / 2, this.padWidth, this.padHeight, "up", "down");
    this.$scope.pads = [this.$scope.pad1, this.$scope.pad2];
    this.$scope.ball = new Ball((this.width - this.ballsize) / 2, (this.height - this.ballsize) / 2, this.ballsize);
    this.$scope.hitDetect = new HitDetector(this.width, this.height);
    this.$scope.status = "Running";
    this.$scope.move = function(key) {
      var pad, _i, _len, _ref, _results;
      _ref = _this.$scope.pads;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        pad = _ref[_i];
        _results.push(pad.pressKey(key));
      }
      return _results;
    };
    this.$scope.stop = function(key) {
      var pad, _i, _len, _ref, _results;
      _ref = _this.$scope.pads;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        pad = _ref[_i];
        _results.push(pad.releaseKey(key));
      }
      return _results;
    };
    this.updateLater();
  }

  GameCtrl.prototype.updateLater = function() {
    var _this = this;
    this.$timeout.cancel(this.updateInterval);
    if (this.$scope.status === "Running") {
      return this.updateInterval = this.$timeout(function() {
        _this.update();
        return _this.updateLater();
      }, 1000 / this.fps);
    }
  };

  GameCtrl.prototype.move = function(key) {
    var pad, _i, _len, _ref, _results;
    _ref = this.$scope.pads;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      pad = _ref[_i];
      _results.push(pad.pressKey(key));
    }
    return _results;
  };

  GameCtrl.prototype.stop = function(key) {
    var pad, _i, _len, _ref, _results;
    _ref = this.$scope.pads;
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
    if (this.$scope.hitDetect.hitLeftWall(this.$scope.ball)) {
      return this.score(1);
    } else if (this.$scope.hitDetect.hitRightWall(this.$scope.ball)) {
      return this.score(0);
    }
  };

  GameCtrl.prototype.score = function(i) {
    this.$scope.score[i] += 1;
    if (this.$scope.score[i] >= this.scoreMax) {
      this.$scope.status = "Player " + (i + 1) + " Wins";
      this.$scope.message = "Player " + (i + 1) + " Wins";
    }
    return this.$scope.ball = new Ball((this.width - this.ballsize) / 2, (this.height - this.ballsize) / 2, this.ballsize);
  };

  GameCtrl.prototype.updateBall = function() {
    if (this.$scope.hitDetect.hit(this.$scope.ball, this.$scope.pad1) || this.$scope.hitDetect.hit(this.$scope.ball, this.$scope.pad2)) {
      if (this.$scope.hitDetect.hitRight(this.$scope.ball, this.$scope.pad1) || this.$scope.hitDetect.hitLeft(this.$scope.ball, this.$scope.pad2)) {
        this.$scope.ball.velocity.x *= -1;
      }
    }
    if (this.$scope.hitDetect.hitVertical(this.$scope.ball, this.$scope.pad1) || this.$scope.hitDetect.hitVertical(this.$scope.ball, this.$scope.pad2) || this.$scope.hitDetect.hitVerticalWall(this.$scope.ball)) {
      this.$scope.ball.velocity.y *= -1;
    }
    this.$scope.ball.pos.x += this.$scope.ball.velocity.x;
    return this.$scope.ball.pos.y += this.$scope.ball.velocity.y;
  };

  GameCtrl.prototype.updatePads = function() {
    var pad, _i, _len, _ref, _results;
    _ref = this.$scope.pads;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      pad = _ref[_i];
      if (this.$scope.hitDetect.hitBottomWall(pad)) {
        _results.push(pad.pos.y = this.height - pad.size.height - 1);
      } else if (this.$scope.hitDetect.hitTopWall(pad)) {
        _results.push(pad.pos.y = 1);
      } else {
        _results.push(pad.pos.y += pad.velocity.y);
      }
    }
    return _results;
  };

  GameCtrl.prototype.redraw = function() {
    this.$scope.pad1style = {
      top: this.$scope.pad1.pos.y
    };
    this.$scope.pad2style = {
      top: this.$scope.pad2.pos.y
    };
    return this.$scope.ballstyle = {
      top: this.$scope.ball.pos.y,
      left: this.$scope.ball.pos.x
    };
  };

  GameCtrl.$inject = ['$scope', '$http', '$timeout', 'Game', 'Pad', 'Ball', 'HitDetector'];

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
    this.$scope.user = "Player 1";
    this.$scope.close = function(result) {
      return _this.dialog.close(result);
    };
    this.$scope.signIn = function() {
      var postData;
      postData = {
        email: _this.$scope.email,
        password: _this.$scope.password
      };
      return _this.$http.post("./login", postData).success(function(data, status, headers, config) {
        _this.$scope.user = data;
        return _this.dialog.close(data);
      }).error(function(data, status, headers, config) {
        _this.$scope.user = "Player 1";
        return _this.dialog.close(false);
      });
    };
  }

  SignInCtrl.$inject = ['$scope', '$http', 'User', 'dialog'];

  return SignInCtrl;

})();
