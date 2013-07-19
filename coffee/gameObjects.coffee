GameObjects = angular.module("gameObjects", [])

class Pos
    constructor: (@x, @y)->
        unless @x?
            @x = 0
        unless @y?
            @y = 0

class Size
    constructor: (@width, @height)->
        unless @width?
            @width = 0
        unless @height?
            @height = 0

class GameObject
    constructor: (@id, xpos, ypos, width, height)->
        @pos = new Pos(xpos, ypos)
        @velocity = new Pos()
        @size = new Size(width, height)

    left: ->
        @pos.x

    right: ->
        @pos.x + @size.width

    top: ->
        @pos.y

    bottom: ->
        @pos.y + @size.height


class Ball extends GameObject
    constructor: (xpos, ypos, ballsize)->
        super "ball", xpos, ypos, ballsize, ballsize
        direction = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
        i = Math.floor Math.random() * 4
        @speed = 7
        @velocity.x = @speed*direction[i][0]
        @velocity.y = @speed*direction[i][1]

Key =
    "w":87
    "s":83
    "up":38
    "down":40

class Pad extends GameObject
    constructor: (id, xpos, ypos, padWidth, padHeight, upKey, downKey)->
        super id, xpos, ypos, padWidth, padHeight
        @up = Key[upKey]
        @down = Key[downKey]
        @speed = 5

    keyResponse: (key, func)->
        if key is @up
            func "up"
        if key is @down
            func "down"

    pressKey: (key)->
        @keyResponse key, @startMove

    releaseKey: (key)->
        @keyResponse key, @endMove

    startMove: (direction)->
        if direction == "up"
            @velocity.y = -@speed
        if direction == "down"
            @velocity.y = @speed

    endMove: (direction)->
        if (direction == "down" and @velocity.y > 0) or (direction == "up" and @velocity.y < 0)
            @velocity.y = 0

class HitDetector
    constructor: (@width, @height)->

    hitWall: (thing)->
        @hitHorizontalWall(thing) or @hitVerticalWall(thing)

    hitHorizontalWall: (thing)->
        @hitLeftWall(thing) or @hitRightWall(thing)

    hitVerticalWall: (thing)->
        @hitTopWall(thing) or @hitBottomWall(thing)

    hitLeftWall: (thing)->
        thing.left() <= 0

    hitRightWall: (thing)->
        thing.right() >= @width

    hitTopWall: (thing)->
        thing.top() <= 0

    hitBottomWall: (thing)->
        thing.bottom() >= @height

    hit: (thing1, thing2)->
        @hitVertical(thing1, thing2) or @hitHorizontal(thing1, thing2)

    hitVertical: (thing1, thing2)->
        @hitTop(thing1, thing2) or @hitBottom(thing1, thing2)

    hitHorizontal: (thing1, thing2)->
        @hitLeft(thing1, thing2) or @hitRight(thing1, thing2)

    hitLeft: (thing1, thing2)->
        thing1.velocity.x > thing2.velocity.x and
        thing1.right() >= thing2.left() and
        (thing1.right() - thing2.left()) <= (thing1.velocity.x - thing2.velocity.x) and
        @inside(thing1, thing2)

    hitRight: (thing1, thing2)->
        thing1.velocity.x < thing2.velocity.x and
        thing1.left() <= thing2.right() and
        (thing2.right() - thing1.left()) <= (thing2.velocity.x - thing1.velocity.x) and
        @inside(thing1, thing2)

    hitTop: (thing1, thing2)->
        thing1.velocity.y > thing2.velocity.y and
        thing1.bottom() >= thing2.top() and
        (thing1.bottom() - thing2.top()) <= (thing1.velocity.y - thing2.velocity.y) and
        @inside(thing1, thing2)

    hitBottom: (thing1, thing2)->
        thing1.velocity.y < thing2.velocity.y and
        thing1.top() <= thing2.bottom() and
        (thing2.bottom() - thing1.top()) <= (thing2.velocity.y - thing1.velocity.y) and
        @inside(thing1, thing2)

    inside: (thing1, thing2)->
        @insideHorizontal(thing1, thing2) and @insideVertical(thing1, thing2)

    insideHorizontal: (thing1, thing2)->
        thing1.right() >= thing2.left() and thing1.left() <= thing2.right()

    insideVertical: (thing1, thing2)->
        thing1.bottom() >= thing2.top() and thing1.top() <= thing2.bottom()


GameObjects.factory "Ball", ->
    Ball

GameObjects.factory "Pad", ->
    Pad

GameObjects.factory "HitDetector", ->
    HitDetector
