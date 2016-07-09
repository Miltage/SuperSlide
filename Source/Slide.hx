package;

import openfl.display.Sprite;
import openfl.Lib;
import openfl.events.MouseEvent;
import openfl.events.KeyboardEvent;
import openfl.geom.Point;
import openfl.Vector;

import box2D.dynamics.*;
import box2D.dynamics.controllers.*;
import box2D.collision.*;
import box2D.collision.shapes.*;
import box2D.common.math.*;

enum Mode {
  DRAW;
  ERASE;
}

typedef Piece = { var p0:Point; var p1:Point; var edge:B2Body; var sprites:Array<Sprite>; @:optional var lastPiece:Piece; @:optional var nextPiece:Piece; }

class Slide extends Sprite {

  public static var worldScale:Float = 30;
  public static var intervals:Int = 15;

  private var world:B2World;
  private var dbgSprite:Sprite;
  private var riderSprite:Sprite;
  private var slideSprite:Sprite;
  private var lastPiece:Piece;

  private var running:Bool;
  private var dragging:Bool;
  private var mouseDown:Bool;

  private var lastPos:Point;
  private var worldOffset:Point;
  private var pieces:Array<Piece>;
  private var riders:Array<Rider>;
  private var mode:Mode;

  public function new() 
  {
    super();

    running = false;
    dragging = false;
    mouseDown = false;
    mode = DRAW;

    riderSprite = new Sprite();
    addChild(riderSprite);

    slideSprite = new Sprite();
    addChild(slideSprite);

    var debug = new B2DebugDraw();
    dbgSprite = new Sprite();
    debug.setFlags(B2DebugDraw.e_shapeBit | B2DebugDraw.e_jointBit);
    debug.setDrawScale(30.0);
    debug.setFillAlpha(0.3);
    debug.setLineThickness(1.0);
    debug.setSprite(dbgSprite);
    addChild(dbgSprite);

    world = new B2World(new B2Vec2 (0, 2), true);
    world.setDebugDraw(debug);
    worldOffset = new Point();
    pieces = new Array<Piece>();
    riders = new Array<Rider>();

    for (i in 0...5)
    {
      var r = new Rider(240+i*80, 100, world, i);
      riderSprite.addChild(r);
      riders.push(r);
    }
  }

  public function update():Void
  {
    if (running)
      world.step(1/Lib.current.stage.frameRate, 10, 10);
    world.clearForces();
    world.drawDebugData();

    this.x = worldOffset.x;
    this.y = worldOffset.y;

    if (running)
      for (rider in riders)
        rider.update();
  }

  private function redraw():Void
  {
    slideSprite.graphics.clear();
    // Draw track
    slideSprite.graphics.beginFill(0xe59751, 1);
    slideSprite.graphics.lineStyle(8, 0xda7a24, 1);

    for (p in pieces)
    {
      slideSprite.graphics.moveTo(p.p0.x, p.p0.y);
      slideSprite.graphics.lineTo(p.p1.x, p.p1.y);
    }
  }

  private function drawSlide(p0:Point, p1:Point):Void
  {
    // Create edge
    var bodyDef = new B2BodyDef();
    bodyDef.type = STATIC_BODY;

    p0 = p0.subtract(worldOffset);
    p1 = p1.subtract(worldOffset);

    var x0 = p0.x;
    var y0 = p0.y;
    var x1 = p1.x;
    var y1 = p1.y;

    var shape = new B2PolygonShape();
    shape.setAsEdge(new B2Vec2(x0 / Slide.worldScale, y0 / Slide.worldScale), new B2Vec2(x1 / Slide.worldScale, y1 / Slide.worldScale));
    var fixture = new B2FixtureDef();
    fixture.shape = shape;

    var edge = world.createBody(bodyDef);
    edge.createFixture(fixture);

    var dx = x1 - x0;
    var dy = y1 - y0;
    var r = Math.atan2(dy,dx) * 180 / Math.PI;

    var sprites:Array<Sprite> = new Array<Sprite>();

    if (lastPiece != null)
    {
      var sx = lastPiece.p0.x;
      var sy = lastPiece.p0.y;
      var sr = lastPiece.sprites[lastPiece.sprites.length-1].rotation;
      var dx = x0 - sx;
      var dy = y0 - sy;
      var dr = r - sr;
      if (dr < -180) dr += 360;
      else if (dr > 180) dr -= 360;

      for (i in 0...(intervals-1))
      {
        // Add slide piece
        var s = new Sprite();
        s.graphics.beginFill(0xe59751, 1);
        s.graphics.drawRoundRect(0, -25, Point.distance(p0, p1)/2, 25, 5);
        s.x = sx + dx/intervals*(i+1);
        s.y = sy + dy/intervals*(i+1);
        s.rotation = sr + dr/intervals*(i+1);
        slideSprite.addChild(s);
        sprites.push(s);
      }
    }
    
    // Add final slide piece
    var s = new Sprite();
    s.graphics.beginFill(0xe59751, 1);
    s.graphics.drawRoundRect(0, -25, Point.distance(p0, p1), 25, 5);
    var dx = x1 - x0;
    var dy = y1 - y0;
    s.rotation = Math.atan2(dy,dx) * 180 / Math.PI;
    s.x = p0.x;
    s.y = p0.y;
    slideSprite.addChild(s);
    sprites.push(s);

    var piece = { p0: p0, p1: p1, edge: edge, sprites: sprites, lastPiece: null };
    pieces.push(piece);
    if (lastPiece != null)
    {
      lastPiece.nextPiece = piece;
      piece.lastPiece = lastPiece;
    }
    lastPiece = piece;

    redraw();
    
  }

  public function onMouseClick(m:MouseEvent):Void
  {

  }

  public function onMouseDown(m:MouseEvent):Void
  {
    mouseDown = true;
    lastPos = new Point(stage.mouseX, stage.mouseY);
  }

  public function onMouseUp(m:MouseEvent):Void
  {
    mouseDown = false;
    lastPiece = null;
  }

  public function onMouseMove(m:MouseEvent):Void
  {
    if (mouseDown && dragging)
    {
      var currentPos = new Point(stage.mouseX, stage.mouseY);
      worldOffset.x += currentPos.x - lastPos.x;
      worldOffset.y += currentPos.y - lastPos.y;
      lastPos = currentPos;
    }
    else if (mouseDown && mode == DRAW)
    {
      var currentPos = new Point(stage.mouseX, stage.mouseY);
      if (Point.distance(currentPos, lastPos) > 25)
      {
        drawSlide(lastPos, currentPos);
        lastPos = currentPos;
      }
    }
    else if (mouseDown && mode == ERASE)
    {
      for (p in pieces)
      { 
        var currentPos = new Point(stage.mouseX, stage.mouseY).subtract(worldOffset);
        var dx = p.p1.x - p.p0.x;
        var dy = p.p1.y - p.p0.y;
        var midPoint = new Point(p.p0.x + dx/2, p.p0.y + dy/2);
        //midPoint.subtract(worldOffset);
        if (Point.distance(currentPos, midPoint) < 25)
        {
          world.destroyBody(p.edge);
          for (sprite in p.sprites)
          {
            if (slideSprite.contains(sprite))
              slideSprite.removeChild(sprite); 
          }
          p.sprites = new Array<Sprite>();

          if (p.nextPiece != null)
          {
            for (i in 0...p.nextPiece.sprites.length-2)
            {
              slideSprite.removeChild(p.nextPiece.sprites[i]); 
            }
            p.nextPiece.lastPiece = null;
          }

          if (p.lastPiece != null)
          {
            p.lastPiece.nextPiece = null;
          }

          pieces.remove(p);
        }
      }
      redraw();
    }
  }

  public function onKeyDown(k:KeyboardEvent):Void
  {
    switch(k.keyCode)
    {
      case 32: // SPACE 
        dragging = true;
    }
  }

  public function onKeyUp(k:KeyboardEvent):Void
  {
    //trace(k.keyCode);
    switch(k.keyCode)
    {
      case 32: // SPACE 
        dragging = false;
      case 13: // ENTER
        running = !running;
    }
  }

  public function setMode(mode:Mode):Void
  {
    this.mode = mode;
  }
  
}