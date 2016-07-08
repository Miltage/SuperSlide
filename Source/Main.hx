package;


import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.KeyboardEvent;

class Main extends Sprite {
	
	private var slide:Slide;
	
	public function new () {
		
		super ();
		stage.color = 0x666666;
		
		slide = new Slide();
		addChild(slide);

		addEventListener(Event.ENTER_FRAME, update);
		stage.addEventListener(MouseEvent.CLICK, slide.onMouseClick);
		stage.addEventListener(MouseEvent.MOUSE_DOWN, slide.onMouseDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, slide.onMouseUp);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, slide.onMouseMove);

		stage.addEventListener(KeyboardEvent.KEY_UP, slide.onKeyUp);

		var fps_mem:FPS_Mem = new FPS_Mem(10, 10, 0xffffff);
		addChild(fps_mem);
		
	}

	public function update(e:Event):Void
  {
  	slide.update();
  }
	
	
}