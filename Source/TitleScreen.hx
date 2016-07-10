package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.Assets;
import openfl.Lib;

class TitleScreen extends Sprite {

  private var title:Sprite;
  
  public function new()
  {
    super();

    title = new Sprite();
    title.addChild(new Bitmap(Assets.getBitmapData("assets/title.png")));
    addChild(title);
  }

  public function onResize(e:Event):Void
  {
    title.x = Lib.current.stage.stageWidth/2 - title.width/2;
    title.y = Lib.current.stage.stageHeight - title.height;
    

    graphics.clear();
    graphics.beginFill(0x96725b, 1);
    graphics.drawRect(0, Lib.current.stage.stageHeight - 161, Lib.current.stage.stageWidth, 161);
  }

}