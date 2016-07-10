package;


import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import openfl.events.MouseEvent;
import openfl.events.KeyboardEvent;

class Main extends Sprite {

  private var slide:Slide;
  private var ui:Sprite;
  private var drawButton:CircleButton;
  private var eraseButton:CircleButton;
  private var resetButton:CircleButton;
  private var deleteButton:CircleButton;

  public function new () {

    super ();
    stage.color = 0x7ad1e5;

    slide = new Slide();
    addChild(slide);

    stage.addEventListener(Event.ENTER_FRAME, update);
    stage.addEventListener(Event.RESIZE, onResize);

    stage.addEventListener(MouseEvent.CLICK, slide.onMouseClick);
    stage.addEventListener(MouseEvent.MOUSE_DOWN, slide.onMouseDown);
    stage.addEventListener(MouseEvent.MOUSE_UP, slide.onMouseUp);
    stage.addEventListener(MouseEvent.MOUSE_MOVE, slide.onMouseMove);

    stage.addEventListener(KeyboardEvent.KEY_DOWN, slide.onKeyDown);
    stage.addEventListener(KeyboardEvent.KEY_UP, slide.onKeyUp);

    ui = new Sprite();
    addChild(ui);

    var fps_mem:FPS_Mem = new FPS_Mem(10, 10, 0xffffff);
    ui.addChild(fps_mem);

    drawButton = new CircleButton("pencil", function(){
      slide.setMode(DRAW);
    });
    drawButton.x = Lib.current.stage.stageWidth - 40 - 150;
    drawButton.y = Lib.current.stage.stageHeight - 40;
    ui.addChild(drawButton);

    eraseButton = new CircleButton("eraser", function(){
      slide.setMode(ERASE);
    });
    eraseButton.x = Lib.current.stage.stageWidth - 40 - 100;
    eraseButton.y = Lib.current.stage.stageHeight - 40;
    ui.addChild(eraseButton);

    resetButton = new CircleButton("refresh", function(){
      slide.reset();
    });
    resetButton.x = Lib.current.stage.stageWidth - 40 - 50;
    resetButton.y = Lib.current.stage.stageHeight - 40;
    ui.addChild(resetButton);

    deleteButton = new CircleButton("garbage", function(){
      slide.reset();
    });
    deleteButton.x = Lib.current.stage.stageWidth - 40;
    deleteButton.y = Lib.current.stage.stageHeight - 40;
    ui.addChild(deleteButton);

  }

  public function update(e:Event):Void
  {
    slide.update();
  }

  public function onResize(e:Event):Void
  {
    drawButton.x = Lib.current.stage.stageWidth - 40 - 50;
    drawButton.y = Lib.current.stage.stageHeight - 40;
    eraseButton.x = Lib.current.stage.stageWidth - 40;
    eraseButton.y = Lib.current.stage.stageHeight - 40;
  }


}