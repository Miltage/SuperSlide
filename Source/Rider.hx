package;

import openfl.display.Sprite;

import box2D.dynamics.*;
import box2D.dynamics.joints.*;
import box2D.dynamics.controllers.*;
import box2D.collision.*;
import box2D.collision.shapes.*;
import box2D.common.math.*;

class Rider extends Sprite {

  private var world:B2World;
  private var index:Int;
  
  public function new(x:Float, y:Float, world:B2World, index:Int)
  {
    super();
    this.x = x;
    this.y = y;
    this.world = world;
    this.index = index;

    createBody(x, y);
  }

  private function createBody(x:Float, y:Float):Void 
  {
    // Create shape
    var bodyDef = new B2BodyDef();
    bodyDef.position.set (x / Slide.worldScale, y / Slide.worldScale);
    bodyDef.type = DYNAMIC_BODY;

    // Head
    var shape:Dynamic = new B2CircleShape(20 / Slide.worldScale);
    //shape.setAsBox(width / Slide.worldScale, height / Slide.worldScale);
    var fixture = new B2FixtureDef();
    fixture.shape = shape;
    fixture.density = 0;
    fixture.restitution = 0.2;
    fixture.friction = 0;
    fixture.filter.groupIndex = -index;

    var head = world.createBody (bodyDef);
    head.createFixture (fixture);

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