(function() {
  var Ball, GameObject, GameObjects, HitDetector, Key, Pad, Pos, Size,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  GameObjects = angular.module("gameObjects", []);

  Pos = (function() {
    function Pos(x, y) {
      this.x = x;
      this.y = y;
      if (this.x == null) {
        this.x = 0;
      }
      if (this.y == null) {
        this.y = 0;
      }
    }

    return Pos;

  })();

  Size = (function() {
    function Size(width, height) {
      this.width = width;
      this.height = height;
      if (this.width == null) {
        this.width = 0;
      }
      if (this.height == null) {
        this.height = 0;
      }
    }

    return Size;

  })();

  GameObject = (function() {
    function GameObject(id, xpos, ypos, width, height) {
      this.id = id;
      this.pos = new Pos(xpos, ypos);
      this.velocity = new Pos(0, 0);
      this.size = new Size(width, height);
    }

    GameObject.prototype.left = function() {
      return this.pos.x;
    };

    GameObject.prototype.right = function() {
      return this.pos.x + this.size.width;
    };

    GameObject.prototype.top = function() {
      return this.pos.y;
    };

    GameObject.prototype.bottom = function() {
      return this.pos.y + this.size.height;
    };

    return GameObject;

  })();

  Ball = (function(_super) {
    __extends(Ball, _super);

    function Ball(xpos, ypos, ballsize) {
      var direction, i;
      Ball.__super__.constructor.call(this, "ball", xpos, ypos, ballsize, ballsize);
      direction = [[-1, -1], [-1, 1], [1, -1], [1, 1]];
      i = Math.floor(Math.random() * 4);
      this.speed = 7;
      this.velocity.x = this.speed * direction[i][0];
      this.velocity.y = this.speed * direction[i][1];
    }

    return Ball;

  })(GameObject);

  Key = {
    "w": 87,
    "s": 83,
    "up": 73,
    "down": 75
  };

  Pad = (function(_super) {
    __extends(Pad, _super);

    function Pad(id, xpos, ypos, padWidth, padHeight, upKey, downKey) {
      this.endMove = __bind(this.endMove, this);
      this.startMove = __bind(this.startMove, this);
      this.releaseKey = __bind(this.releaseKey, this);
      this.pressKey = __bind(this.pressKey, this);
      this.keyResponse = __bind(this.keyResponse, this);
      Pad.__super__.constructor.call(this, id, xpos, ypos, padWidth, padHeight);
      this.up = Key[upKey];
      this.down = Key[downKey];
      this.speed = 5;
    }

    Pad.prototype.keyResponse = function(key, func) {
      if (key === this.up) {
        func("up");
      }
      if (key === this.down) {
        return func("down");
      }
    };

    Pad.prototype.pressKey = function(key) {
      return this.keyResponse(key, this.startMove);
    };

    Pad.prototype.releaseKey = function(key) {
      return this.keyResponse(key, this.endMove);
    };

    Pad.prototype.startMove = function(direction) {
      if (direction === "up") {
        this.velocity.y = -this.speed;
      }
      if (direction === "down") {
        return this.velocity.y = this.speed;
      }
    };

    Pad.prototype.endMove = function(direction) {
      if ((direction === "down" && this.velocity.y > 0) || (direction === "up" && this.velocity.y < 0)) {
        return this.velocity.y = 0;
      }
    };

    return Pad;

  })(GameObject);

  HitDetector = (function() {
    function HitDetector(width, height) {
      this.width = width;
      this.height = height;
    }

    HitDetector.prototype.hitWall = function(thing) {
      return this.hitHorizontalWall(thing) || this.hitVerticalWall(thing);
    };

    HitDetector.prototype.hitHorizontalWall = function(thing) {
      return this.hitLeftWall(thing) || this.hitRightWall(thing);
    };

    HitDetector.prototype.hitVerticalWall = function(thing) {
      return this.hitTopWall(thing) || this.hitBottomWall(thing);
    };

    HitDetector.prototype.hitLeftWall = function(thing) {
      return thing.left() <= 0;
    };

    HitDetector.prototype.hitRightWall = function(thing) {
      return thing.right() >= this.width;
    };

    HitDetector.prototype.hitTopWall = function(thing) {
      return thing.top() <= 0;
    };

    HitDetector.prototype.hitBottomWall = function(thing) {
      return thing.bottom() >= this.height;
    };

    HitDetector.prototype.hit = function(thing1, thing2) {
      return this.hitVertical(thing1, thing2) || this.hitHorizontal(thing1, thing2);
    };

    HitDetector.prototype.hitVertical = function(thing1, thing2) {
      return this.hitTop(thing1, thing2) || this.hitBottom(thing1, thing2);
    };

    HitDetector.prototype.hitHorizontal = function(thing1, thing2) {
      return this.hitLeft(thing1, thing2) || this.hitRight(thing1, thing2);
    };

    HitDetector.prototype.hitLeft = function(thing1, thing2) {
      return thing1.velocity.x > thing2.velocity.x && thing1.right() >= thing2.left() && (thing1.right() - thing2.left()) <= (thing1.velocity.x - thing2.velocity.x) && this.inside(thing1, thing2);
    };

    HitDetector.prototype.hitRight = function(thing1, thing2) {
      return thing1.velocity.x < thing2.velocity.x && thing1.left() <= thing2.right() && (thing2.right() - thing1.left()) <= (thing2.velocity.x - thing1.velocity.x) && this.inside(thing1, thing2);
    };

    HitDetector.prototype.hitTop = function(thing1, thing2) {
      return thing1.velocity.y > thing2.velocity.y && thing1.bottom() >= thing2.top() && (thing1.bottom() - thing2.top()) <= (thing1.velocity.y - thing2.velocity.y) && this.inside(thing1, thing2);
    };

    HitDetector.prototype.hitBottom = function(thing1, thing2) {
      return thing1.velocity.y < thing2.velocity.y && thing1.top() <= thing2.bottom() && (thing2.bottom() - thing1.top()) <= (thing2.velocity.y - thing1.velocity.y) && this.inside(thing1, thing2);
    };

    HitDetector.prototype.inside = function(thing1, thing2) {
      return this.insideHorizontal(thing1, thing2) && this.insideVertical(thing1, thing2);
    };

    HitDetector.prototype.insideHorizontal = function(thing1, thing2) {
      return thing1.right() >= thing2.left() && thing1.left() <= thing2.right();
    };

    HitDetector.prototype.insideVertical = function(thing1, thing2) {
      return thing1.bottom() >= thing2.top() && thing1.top() <= thing2.bottom();
    };

    return HitDetector;

  })();

  GameObjects.factory("Ball", function() {
    return Ball;
  });

  GameObjects.factory("Pad", function() {
    return Pad;
  });

  GameObjects.factory("HitDetector", function() {
    return HitDetector;
  });

}).call(this);
