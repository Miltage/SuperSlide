package;

import box2D.dynamics.*;
import box2D.dynamics.controllers.*;
import box2D.dynamics.contacts.*;
import box2D.collision.*;
import box2D.collision.shapes.*;
import box2D.common.math.*;

class ContactHandler extends B2ContactListener {

  public function new()
  {
    super();
  }

  override public function beginContact(contact:B2Contact):Void 
  {
    
  }

  override public function postSolve(contact:B2Contact, impulse:B2ContactImpulse):Void 
  {
    var b0 = contact.getFixtureA().getBody().getUserData();
    var b1 = contact.getFixtureB().getBody().getUserData();
    if (b0 != null && Std.is(b0, Rider) || b1 != null && Std.is(b1, Rider))
    {
      trace(impulse.normalImpulses[0]);
    }
  }
  
}