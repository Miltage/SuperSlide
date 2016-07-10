package;

import openfl.display.Sprite;

import box2D.dynamics.*;
import box2D.dynamics.joints.*;
import box2D.dynamics.controllers.*;
import box2D.collision.*;
import box2D.collision.shapes.*;
import box2D.common.math.*;

class WaterDrop extends Sprite {

  private var world:B2World;
  private var body:B2Body;
    
  public function new(x:Float, y:Float, world:B2World)
  {
    super();

    this.x = x;
    this.y = y;
    this.world = world;

    createBody();

    graphics.beginFill(0xc3e8f1, 1);
    graphics.drawCircle(0, 0, 2);
  }

  public function createBody():Void
  {
    var bodyDef = new B2BodyDef();
    bodyDef.position.set (x / Slide.worldScale, y / Slide.worldScale);
    bodyDef.type = DYNAMIC_BODY;

    // Body 1
    var shape:Dynamic = new B2CircleShape(3 / Slide.worldScale);
    var fixture = new B2FixtureDef();
    fixture.shape = shape;
    fixture.density = 0;
    fixture.restitution = 0.3;
    fixture.friction = 0;
    fixture.filter.groupIndex = 0;

    body = world.createBody (bodyDef);
    body.createFixture (fixture);
  }

  public function update(water:Array<WaterDrop>):Void
  {
    this.x = body.getWorldCenter().x * Slide.worldScale;
    this.y = body.getWorldCenter().y * Slide.worldScale;
  }



}