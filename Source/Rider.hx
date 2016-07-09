package;

import openfl.display.Sprite;

import box2D.dynamics.*;
import box2D.dynamics.controllers.*;
import box2D.collision.*;
import box2D.collision.shapes.*;
import box2D.common.math.*;

class Rider extends Sprite {

  private var world:B2World;
  
  public function new(x:Float, y:Float, world:B2World)
  {
    super();
    this.x = x;
    this.y = y;
    this.world = world;

    createBody(x, y, 15, 20);
  }

  private function createBody(x:Float, y:Float, width:Int, height:Int):Void 
  {
    // Create shape
    var bodyDef = new B2BodyDef();
    bodyDef.position.set (x / Slide.worldScale, y / Slide.worldScale);
    bodyDef.type = DYNAMIC_BODY;

    var shape = new B2CircleShape(width / Slide.worldScale);
    //shape.setAsBox(width / Slide.worldScale, height / Slide.worldScale);
    var fixture = new B2FixtureDef();
    fixture.shape = shape;
    fixture.density = 20;
    fixture.restitution = 0.2;
    fixture.friction = 0;

    var body = world.createBody (bodyDef);
    body.createFixture (fixture);
  }
}