package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Assets;
import openfl.geom.Point;

import motion.Actuate;

import box2D.dynamics.*;
import box2D.dynamics.joints.*;
import box2D.dynamics.controllers.*;
import box2D.collision.*;
import box2D.collision.shapes.*;
import box2D.common.math.*;

class Rider extends Sprite {

  private var world:B2World;
  private var body:B2Body;
  private var body2:B2Body;
  private var index:Int;

  private var arm1:Sprite;
  private var arm2:Sprite;
  private var leg1:Sprite;
  private var leg2:Sprite;
  private var torso:Sprite;
  private var head:Sprite;

  private var vel:Point;
  private var start:Point;
  
  public function new(x:Float, y:Float, world:B2World, index:Int)
  {
    super();
    this.x = x;
    this.y = y;
    this.world = world;
    this.index = index;

    start = new Point(x, y);

    var e:Int = Std.int(Math.random()*2);
    var g:Int = Std.int(Math.random()*2);

    vel = new Point();

    createBody(x, y);

    arm1 = new Sprite();
    {
      var bmp = new Bitmap(Assets.getBitmapData("assets/arm"+(e==0?"1":"3")+".png"));
      arm1.addChild(bmp);
      bmp.x -= 33;
      bmp.y -= 32;
      arm1.x = -arm1.width/2 + 33;
      arm1.y = -arm1.height/2 + 32;
    }
    addChild(arm1);

    leg1 = new Sprite();
    {
      var bmp = new Bitmap(Assets.getBitmapData("assets/leg"+(e==0?"1":"3")+".png"));
      leg1.addChild(bmp);
      bmp.x -= 62;
      bmp.y -= 41;
      leg1.x = -leg1.width/2 + 62;
      leg1.y = -leg1.height/2 + 41;
    }
    addChild(leg1);

    leg2 = new Sprite();
    {
      var bmp = new Bitmap(Assets.getBitmapData("assets/leg"+(e==0?"2":"4")+".png"));
      leg1.addChild(bmp);
      bmp.x -= 62;
      bmp.y -= 38;
      leg2.x = -leg2.width/2 + 62;
      leg2.y = -leg2.height/2 + 38;
    }
    addChild(leg2);

    torso = new Sprite();
    {
      var t:Int = e == 0 ? Std.int(Math.random()*3)+1 : Std.int(Math.random()*3)+4;
      t += g*6;
      torso.addChild(new Bitmap(Assets.getBitmapData("assets/torso"+t+".png")));
      torso.x = -torso.width/2;
      torso.y = -torso.height/2;
    }
    addChild(torso);

    head = new Sprite();
    {
      var h:Int = e == 0 ? Std.int(Math.random()*3)+1+g*4 : 4+g*4;
      head.addChild(new Bitmap(Assets.getBitmapData("assets/head"+h+".png")));
      head.x = -head.width/2;
      head.y = -head.height/2;
    }
    addChild(head);

    arm2 = new Sprite();
    {
      var bmp = new Bitmap(Assets.getBitmapData("assets/arm"+(e==0?"2":"4")+".png"));
      arm2.addChild(bmp);
      bmp.x -= 36;
      bmp.y -= 36;
      arm2.x = -arm2.width/2 + 36;
      arm2.y = -arm2.height/2 + 36;
    }
    addChild(arm2);

    reset();
  }

  public function update():Void
  {
    this.x = (body.getWorldCenter().x + (body2.getWorldCenter().x - body.getWorldCenter().x)/2) * Slide.worldScale;
    this.y = (body.getWorldCenter().y + (body2.getWorldCenter().y - body.getWorldCenter().y)/2) * Slide.worldScale - 10;

    var bodyVel = body.getLinearVelocity();
    vel.y += (bodyVel.y - vel.y)/10;

    arm2.rotation = Math.min(70, vel.y*15);
    arm1.rotation = Math.min(50, vel.y*10);
    leg1.rotation = Math.max(-40, -vel.y*12);
    leg2.rotation = Math.max(-40, -vel.y*8);

    var dx = body2.getWorldCenter().x - body.getWorldCenter().x;
    var dy = body2.getWorldCenter().y - body.getWorldCenter().y;
    var r = Math.atan2(dy,dx) * 180 / Math.PI;
    rotation = r;
  }

  public function takeDamage(amount:Float):Void
  {
    if (amount < 3) return;
    Actuate.transform (this, 0.25).color (0x880000, amount/6).onComplete(function(){
        Actuate.transform (this, 0.25).color (0xffffff, 0);
    });
  }

  public function reset():Void
  {
    body.setPosition(new B2Vec2((start.x - 15) / Slide.worldScale, start.y / Slide.worldScale));
    body2.setPosition(new B2Vec2((start.x + 15) / Slide.worldScale, start.y / Slide.worldScale));
    body.setLinearVelocity(new B2Vec2());
    body2.setLinearVelocity(new B2Vec2());

    vel = new Point();

    update();
  }

  private function createBody(x:Float, y:Float):Void 
  {
    // Create shape
    var bodyDef = new B2BodyDef();
    bodyDef.position.set ((x - 15) / Slide.worldScale, y / Slide.worldScale);
    bodyDef.type = DYNAMIC_BODY;

    // Body 1
    var shape:Dynamic = new B2CircleShape(15 / Slide.worldScale);
    //shape.setAsBox(width / Slide.worldScale, height / Slide.worldScale);
    var fixture = new B2FixtureDef();
    fixture.shape = shape;
    fixture.density = 0;
    fixture.restitution = 0.2;
    fixture.friction = 0;
    fixture.filter.groupIndex = -index;

    body = world.createBody (bodyDef);
    body.createFixture (fixture);
    body.setUserData(this);

    bodyDef = new B2BodyDef();
    bodyDef.position.set (x / Slide.worldScale, y / Slide.worldScale);
    bodyDef.type = DYNAMIC_BODY;

    // Body 2
    bodyDef.position.set ((x + 15) / Slide.worldScale, y / Slide.worldScale);
    var fixture = new B2FixtureDef();
    fixture.shape = shape;
    fixture.density = 0;
    fixture.restitution = 0.2;
    fixture.friction = 0;
    fixture.filter.groupIndex = -index;

    body2 = world.createBody (bodyDef);
    body2.createFixture (fixture);
    body2.setUserData(this);

    var jointDef = new B2DistanceJointDef();
    jointDef.initialize(body, body2, body.getWorldCenter(), body2.getWorldCenter());
    world.createJoint(jointDef);

    /*// Torso
    bodyDef.position.set (x / Slide.worldScale, (y + 30) / Slide.worldScale);

    shape = new B2PolygonShape();
    shape.setAsBox(10 / Slide.worldScale, 20 / Slide.worldScale);
    fixture = new B2FixtureDef();
    fixture.shape = shape;
    fixture.density = 20;
    fixture.restitution = 0.2;
    fixture.friction = 0;
    fixture.filter.groupIndex = -index;

    var torso = world.createBody (bodyDef);
    torso.createFixture (fixture);

    // Neck
    var jointDef:Dynamic = new B2RevoluteJointDef();
    jointDef.initialize(head, torso, torso.getWorldCenter());
    jointDef.enableLimit = true;
    world.createJoint(jointDef);

    // Left Arm
    bodyDef.position.set ((x-20) / Slide.worldScale, (y + 20) / Slide.worldScale);

    shape = new B2PolygonShape();
    shape.setAsBox(5 / Slide.worldScale, 5 / Slide.worldScale);
    fixture = new B2FixtureDef();
    fixture.shape = shape;
    fixture.density = 1;
    fixture.restitution = 0.2;
    fixture.friction = 0;
    fixture.filter.groupIndex = -index;

    var leftArm = world.createBody (bodyDef);
    leftArm.createFixture (fixture);

    jointDef = new B2DistanceJointDef();
    jointDef.initialize(leftArm, torso, leftArm.getWorldPoint(new B2Vec2(5/Slide.worldScale, 0)), torso.getWorldPoint(new B2Vec2(-10 / Slide.worldScale, -15 / Slide.worldScale)));
    world.createJoint(jointDef);

    // Left Forearm
    bodyDef.position.set ((x-35) / Slide.worldScale, (y + 20) / Slide.worldScale);

    shape = new B2PolygonShape();
    shape.setAsBox(5 / Slide.worldScale, 5 / Slide.worldScale);
    fixture = new B2FixtureDef();
    fixture.shape = shape;
    fixture.density = 1;
    fixture.restitution = 0.2;
    fixture.friction = 0;
    fixture.filter.groupIndex = -index;

    var leftForearm = world.createBody (bodyDef);
    leftForearm.createFixture (fixture);

    jointDef = new B2DistanceJointDef();
    jointDef.initialize(leftForearm, leftArm, leftForearm.getWorldPoint(new B2Vec2(5/Slide.worldScale, 0)), leftArm.getWorldPoint(new B2Vec2(-5 / Slide.worldScale, 0)));
    world.createJoint(jointDef);

    // Right Arm
    bodyDef.position.set ((x+20) / Slide.worldScale, (y + 20) / Slide.worldScale);

    shape = new B2PolygonShape();
    shape.setAsBox(5 / Slide.worldScale, 5 / Slide.worldScale);
    fixture = new B2FixtureDef();
    fixture.shape = shape;
    fixture.density = 1;
    fixture.restitution = 0.2;
    fixture.friction = 0;
    fixture.filter.groupIndex = -index;

    var rightArm = world.createBody (bodyDef);
    rightArm.createFixture (fixture);

    jointDef = new B2DistanceJointDef();
    jointDef.initialize(rightArm, torso, rightArm.getWorldPoint(new B2Vec2(-5/Slide.worldScale, 0)), torso.getWorldPoint(new B2Vec2(10 / Slide.worldScale, -15 / Slide.worldScale)));
    world.createJoint(jointDef);

    // Right Forearm
    bodyDef.position.set ((x+35) / Slide.worldScale, (y + 20) / Slide.worldScale);

    shape = new B2PolygonShape();
    shape.setAsBox(5 / Slide.worldScale, 5 / Slide.worldScale);
    fixture = new B2FixtureDef();
    fixture.shape = shape;
    fixture.density = 1;
    fixture.restitution = 0.2;
    fixture.friction = 0;
    fixture.filter.groupIndex = -index;

    var rightForearm = world.createBody (bodyDef);
    rightForearm.createFixture (fixture);

    jointDef = new B2DistanceJointDef();
    jointDef.initialize(rightForearm, rightArm, rightForearm.getWorldPoint(new B2Vec2(-5/Slide.worldScale, 0)), rightArm.getWorldPoint(new B2Vec2(5 / Slide.worldScale, 0)));
    world.createJoint(jointDef);

    // Left Leg
    bodyDef.position.set ((x-6) / Slide.worldScale, (y + 60) / Slide.worldScale);

    shape = new B2PolygonShape();
    shape.setAsBox(5 / Slide.worldScale, 5 / Slide.worldScale);
    fixture = new B2FixtureDef();
    fixture.shape = shape;
    fixture.density = 1;
    fixture.restitution = 0.2;
    fixture.friction = 0;
    fixture.filter.groupIndex = -index;

    var leftLeg = world.createBody (bodyDef);
    leftLeg.createFixture (fixture);

    jointDef = new B2DistanceJointDef();
    jointDef.initialize(leftLeg, torso, leftLeg.getWorldPoint(new B2Vec2(0, -5/Slide.worldScale)), torso.getWorldPoint(new B2Vec2(-6 / Slide.worldScale, 20 / Slide.worldScale)));
    world.createJoint(jointDef);

    // Left Shin
    bodyDef.position.set ((x-6) / Slide.worldScale, (y + 80) / Slide.worldScale);

    shape = new B2PolygonShape();
    shape.setAsBox(5 / Slide.worldScale, 8 / Slide.worldScale);
    fixture = new B2FixtureDef();
    fixture.shape = shape;
    fixture.density = 1;
    fixture.restitution = 0.2;
    fixture.friction = 0;
    fixture.filter.groupIndex = -index;

    var leftShin = world.createBody (bodyDef);
    leftShin.createFixture (fixture);

    jointDef = new B2DistanceJointDef();
    jointDef.initialize(leftShin, leftLeg, leftShin.getWorldPoint(new B2Vec2(0, -8/Slide.worldScale)), leftLeg.getWorldPoint(new B2Vec2(0, 5/Slide.worldScale)));
    world.createJoint(jointDef);

    // Right Leg
    bodyDef.position.set ((x+6) / Slide.worldScale, (y + 60) / Slide.worldScale);

    shape = new B2PolygonShape();
    shape.setAsBox(5 / Slide.worldScale, 5 / Slide.worldScale);
    fixture = new B2FixtureDef();
    fixture.shape = shape;
    fixture.density = 1;
    fixture.restitution = 0.2;
    fixture.friction = 0;
    fixture.filter.groupIndex = -index;

    var rightLeg = world.createBody (bodyDef);
    rightLeg.createFixture (fixture);

    jointDef = new B2DistanceJointDef();
    jointDef.initialize(rightLeg, torso, rightLeg.getWorldPoint(new B2Vec2(0, -5/Slide.worldScale)), torso.getWorldPoint(new B2Vec2(6 / Slide.worldScale, 20 / Slide.worldScale)));
    world.createJoint(jointDef);

    // Right Shin
    bodyDef.position.set ((x+6) / Slide.worldScale, (y + 80) / Slide.worldScale);

    shape = new B2PolygonShape();
    shape.setAsBox(5 / Slide.worldScale, 8 / Slide.worldScale);
    fixture = new B2FixtureDef();
    fixture.shape = shape;
    fixture.density = 1;
    fixture.restitution = 0.2;
    fixture.friction = 0;
    fixture.filter.groupIndex = -index;

    var rightShin = world.createBody (bodyDef);
    rightShin.createFixture (fixture);

    jointDef = new B2DistanceJointDef();
    jointDef.initialize(rightShin, rightLeg, rightShin.getWorldPoint(new B2Vec2(0, -8/Slide.worldScale)), rightLeg.getWorldPoint(new B2Vec2(0, 5/Slide.worldScale)));
    world.createJoint(jointDef);*/
  }
}