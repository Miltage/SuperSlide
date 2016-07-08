package;

import openfl.display.Sprite;
import openfl.Lib;
import openfl.events.MouseEvent;
import openfl.events.KeyboardEvent;
import openfl.geom.Point;

import box2D.dynamics.*;
import box2D.dynamics.controllers.*;
import box2D.collision.*;
import box2D.collision.shapes.*;
import box2D.common.math.*;

class Slide extends Sprite {

  public static var worldScale:Float = 30;

  private var world:B2World;
  private var dbgSprite:Sprite;

  private var running:Bool;
  private var mouseDown:Bool;

  private var lastPos:Point;

  public function new() 
  {
    super();

    running = false;
    mouseDown = false;

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
    createBody(240+i*40, 100, 10, 20);
  }

  public function update():Void
  {
    if (running)
      world.step(1/Lib.current.stage.frameRate, 10, 10);
    world.clearForces();
    world.drawDebugData();
  }

  private function drawSlide(p0:Point, p1:Point):Void
  {
    // Create edge
    var bodyDef = new B2BodyDef();
    bodyDef.type = STATIC_BODY;

    var shape = new B2PolygonShape();
    shape.setAsEdge(new B2Vec2(p0.x / Slide.worldScale, p0.y / Slide.worldScale), new B2Vec2(p1.x / Slide.worldScale, p1.y / Slide.worldScale));
    var fixture = new B2FixtureDef();
    fixture.shape = shape;

    var edge = world.createBody(bodyDef);
    edge.createFixture(fixture);
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
    lastPos = new Point(m.localX, m.localY);
  }

  public function onMouseUp(m:MouseEvent):Void
  {
    mouseDown = false;
  }

  public function onMouseMove(m:MouseEvent):Void
  {
    if (mouseDown)
    {
      var currentPos = new Point(m.localX, m.localY);
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