package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Assets;
import openfl.events.MouseEvent;
import openfl.geom.ColorTransform;

class CircleButton extends Button {

  var circle:Sprite;
  var iconBmp:Bitmap;
  
  public function new(icon:String, onClick:Void->Void)
  {
    super(onClick);

    circle = new Sprite();
    circle.graphics.beginFill(0xefefef, 1);
    circle.graphics.drawCircle(0, 0, 20);
    addChild(circle);

    iconBmp = new Bitmap(Assets.getBitmapData("assets/"+icon+".png"));
    iconBmp.x = -iconBmp.width/2;
    iconBmp.y = -iconBmp.height/2;
    addChild(iconBmp);
  }

  override public function onMouseOver(m:MouseEvent):Void
  {
    circle.scaleX = 1.05;
    circle.scaleY = 1.05;
  }

  override public function onMouseOut(m:MouseEvent):Void
  {
    circle.scaleX = 1;
    circle.scaleY = 1;
  }

  override public function onMouseDown(m:MouseEvent):Void
  {
    circle.transform.colorTransform = new ColorTransform(.95, .95, .95, 1);
    circle.scaleX = .98;
    circle.scaleY = .98;
  }

  override public function onMouseUp(m:MouseEvent):Void
  {
    super.onMouseUp(m);

    circle.transform.colorTransform = new ColorTransform(1, 1, 1, 1);
    circle.scaleX = 1.05;
    circle.scaleY = 1.05;
  }
}