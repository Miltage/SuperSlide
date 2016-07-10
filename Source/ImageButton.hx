package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Assets;
import openfl.events.MouseEvent;
import openfl.geom.ColorTransform;

class ImageButton extends Button {

  var circle:Sprite;
  var imageBmp:Bitmap;
  
  public function new(image:String, onClick:Void->Void)
  {
    super(onClick);

    buttonMode = true;
    useHandCursor = true;

    imageBmp = new Bitmap(Assets.getBitmapData("assets/"+image+".png"));
    imageBmp.x = -imageBmp.width/2;
    imageBmp.y = -imageBmp.height/2;
    addChild(imageBmp);
  }

  override public function onMouseOver(m:MouseEvent):Void
  {
    transform.colorTransform = new ColorTransform(.6, .6, .6, 1);
  }

  override public function onMouseOut(m:MouseEvent):Void
  {
    transform.colorTransform = new ColorTransform(1, 1, 1, 1);
  }

  override public function onMouseDown(m:MouseEvent):Void
  {
    transform.colorTransform = new ColorTransform(.2, .2, .2, 1);
  }

  override public function onMouseUp(m:MouseEvent):Void
  {
    super.onMouseUp(m);

    transform.colorTransform = new ColorTransform(1, 1, 1, 1);
  }
}