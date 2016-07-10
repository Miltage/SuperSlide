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
  private var playButton:CircleButton;
  private var pauseButton:CircleButton;

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

    #if debug
    var fps_mem:FPS_Mem = new FPS_Mem(10, 10, 0xffffff);
    ui.addChild(fps_mem);
    #end

    pauseButton = new CircleButton("pause", function(){
      slide.stop();
      pauseButton.visible = false;
      playButton.visible = true;
    });
    pauseButton.visible = false;
    ui.addChild(pauseButton);

    playButton = new CircleButton("play", function(){
      slide.play();
      pauseButton.visible = true;
      playButton.visible = false;
    });
    ui.addChild(playButton);

    drawButton = new CircleButton("pencil", function(){
      slide.setMode(DRAW);
    });
    ui.addChild(drawButton);

    eraseButton = new CircleButton("eraser", function(){
      slide.setMode(ERASE);
    });
    ui.addChild(eraseButton);

    resetButton = new CircleButton("refresh", function(){
      slide.reset();
    });
    ui.addChild(resetButton);

    deleteButton = new CircleButton("garbage", function(){
      slide.eraseAll();
    });
    ui.addChild(deleteButton);

    onResize(null);

  }

  public function update(e:Event):Void
  {
    slide.update();
  }

  public function onResize(e:Event):Void
  {
  	// Position buttons
  	pauseButton.x = Lib.current.stage.stageWidth - 40 - 200;
  	pauseButton.y = Lib.current.stage.stageHeight - 40;
  	playButton.x = Lib.current.stage.stageWidth - 40 - 200;
  	playButton.y = Lib.current.stage.stageHeight - 40;
    drawButton.x = Lib.current.stage.stageWidth - 40 - 150;
    drawButton.y = Lib.current.stage.stageHeight - 40;
    eraseButton.x = Lib.current.stage.stageWidth - 40 - 100;
    eraseButton.y = Lib.current.stage.stageHeight - 40;
    resetButton.x = Lib.current.stage.stageWidth - 40 - 50;
    resetButton.y = Lib.current.stage.stageHeight - 40;    
    deleteButton.x = Lib.current.stage.stageWidth - 40;
    deleteButton.y = Lib.current.stage.stageHeight - 40;
  }


}