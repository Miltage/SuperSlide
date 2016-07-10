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
    
  }

}