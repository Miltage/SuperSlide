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

typedef Piece = { var p0:Point; var p1:Point; var edge:B2Body; var sprites:Array<Sprite>; }

class Slide extends Sprite {

  public static var worldScale:Float = 30;
  public static var intervals:Int = 15;

  private var world:B2World;
  private var dbgSprite:Sprite;
  private var slideSprite:Sprite;
  private var lastPiece:Sprite;
  private var drawButton:CircleButton;
  private var eraseButton:CircleButton;

  private var running:Bool;
  private var mouseDown:Bool;

  private var lastPos:Point;
  private var worldOffset:Point;
  private var pieces:Array<Piece>;

  public function new() 
  {
    super();

    running = false;
    mouseDown = false;

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

    // Create edge
    var bodyDef = new B2BodyDef();
    bodyDef.type = STATIC_BODY;

    var shape = new B2PolygonShape();
    shape.setAsEdge(new B2Vec2(250 / Slide.worldScale, 400 / Slide.worldScale), new B2Vec2(600 / Slide.worldScale, 400 / Slide.worldScale));
    var fixture = new B2FixtureDef();
    fixture.shape = shape;

    //var edge = world.createBody(bodyDef);
    //edge.createFixture(fixture);

    for (i in 0...10)
    createBody(240+i*40, 100, 15, 20);

    drawButton = new CircleButton("pencil", function(){

    });
    drawButton.x = Lib.current.stage.stageWidth - 40 - 50;
    drawButton.y = Lib.current.stage.stageHeight - 40;
    addChild(drawButton);

    eraseButton = new CircleButton("eraser", function(){

    });
    eraseButton.x = Lib.current.stage.stageWidth - 40;
    eraseButton.y = Lib.current.stage.stageHeight - 40;
    addChild(eraseButton);
  }

  public function update():Void
  {
    if (running)
      world.step(1/Lib.current.stage.frameRate, 10, 10);
    world.clearForces();
    world.drawDebugData();

    this.x = worldOffset.x;
    this.y = worldOffset.y;
  }

  private function drawSlide(p0:Point, p1:Point):Void
  {
    // Create edge
    var bodyDef = new B2BodyDef();
    bodyDef.type = STATIC_BODY;

    var x0 = (p0.x - worldOffset.x);
    var y0 = (p0.y - worldOffset.y);
    var x1 = (p1.x - worldOffset.x);
    var y1 = (p1.y - worldOffset.y);

    var shape = new B2PolygonShape();
    shape.setAsEdge(new B2Vec2(x0 / Slide.worldScale, y0 / Slide.worldScale), new B2Vec2(x1 / Slide.worldScale, y1 / Slide.worldScale));
    var fixture = new B2FixtureDef();
    fixture.shape = shape;

    var edge = world.createBody(bodyDef);
    edge.createFixture(fixture);

    // Draw slide
    slideSprite.graphics.beginFill(0xdefec8, 1);
    slideSprite.graphics.lineStyle(8, 0x333333, 1);

    slideSprite.graphics.moveTo(x0, y0);
    slideSprite.graphics.lineTo(x1, y1);

    var dx = x1 - x0;
    var dy = y1 - y0;
    var r = Math.atan2(dy,dx) * 180 / Math.PI;

    var sprites:Array<Sprite> = new Array<Sprite>();

    if (lastPiece != null)
    {
      var sx = lastPiece.x;
      var sy = lastPiece.y;
      var sr = lastPiece.rotation;
      var dx = x0 - sx;
      var dy = y0 - sy;
      var dr = r - sr;
      if (dr < -180) dr += 360;
      else if (dr > 180) dr -= 360;
      for (i in 0...(intervals-1))
      {
        // Add slide piece
        var s = new Sprite();
        s.graphics.beginFill(0xdefec8, 1);
        s.graphics.drawRoundRect(0, -40, Point.distance(p0, p1)/2, 40, 5);
        s.x = sx + dx/intervals*(i+1);
        s.y = sy + dy/intervals*(i+1);
        s.rotation = sr + dr/intervals*(i+1);
        slideSprite.addChild(s);
        sprites.push(s);
        lastPiece = s;
      }
    }
    
    // Add final slide piece
    var s = new Sprite();
    s.graphics.beginFill(0xdefec8, 1);
    s.graphics.drawRoundRect(0, -40, Point.distance(p0, p1), 40, 5);
    var dx = x1 - x0;
    var dy = y1 - y0;
    s.rotation = Math.atan2(dy,dx) * 180 / Math.PI;
    s.x = p0.x - x;
    s.y = p0.y - y;
    slideSprite.addChild(s);
    sprites.push(s);
    lastPiece = s;

    var piece = { p0: p0, p1: p1, edge: edge, sprites: sprites };
    pieces.push(piece);
    
  }

  private function createBody(x:Int, y:Int, width:Int, height:Int):Void 
  {
    // Create shape
    var bodyDef = new B2BodyDef();
    bodyDef.position.set (x / Slide.worldScale, y / Slide.worldScale);
    bodyDef.type = DYNAMIC_BODY;

    var shape = new B2CircleShape(width / Slide.worldScale);
    //shape.setAsBox(width / Slide.worldScale, height / Slide.worldScale);
    var fixture = new B2FixtureDef();
    fixture.shape = shape;
    fixture.density = 4;
    fixture.restitution = 0.2;
    fixture.friction = 0;

    var body = world.createBody (bodyDef);
    body.createFixture (fixture);
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
    if (mouseDown && m.altKey)
    {
      var currentPos = new Point(stage.mouseX, stage.mouseY);
      worldOffset.x += currentPos.x - lastPos.x;
      worldOffset.y += currentPos.y - lastPos.y;
      lastPos = currentPos;
    }
    else if (mouseDown)
    {
      var currentPos = new Point(stage.mouseX, stage.mouseY);
      if (Point.distance(currentPos, lastPos) > 25)
      {
        drawSlide(lastPos, currentPos);
        lastPos = currentPos;
      }
    }
  }

  public function onKeyUp(k:KeyboardEvent):Void
  {
    
    switch(k.keyCode)
    {
      case 32: // SPACE 
        running = !running;
    }
  }
  
}