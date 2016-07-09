package;

import openfl.display.Sprite;
import openfl.events.MouseEvent;

class Button extends Sprite {

  private var onClick:Void->Void;
  
  public function new(onClick:Void->Void)
  {
    super();
    this.onClick = onClick;

    addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
    addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
    addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
    addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
  }

  public function onMouseOver(m:MouseEvent):Void
  {

  }

  public function onMouseOut(m:MouseEvent):Void
  {

  }

  public function onMouseDown(m:MouseEvent):Void
  {

  }

  public function onMouseUp(m:MouseEvent):Void
  {
    if (onClick != null)
      onClick();
  }
}