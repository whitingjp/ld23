package Src
{
  import mx.core.*;
  import mx.collections.*;
  import mx.containers.*;
  import flash.display.*;
  import flash.geom.*;
  import flash.events.*;
  import flash.text.*;
  import flash.utils.*;
  import flash.ui.Keyboard;
  import Src.FE.*;
  import Src.Entity.*;
  import Src.Gfx.*;
  import Src.Sound.*;
  import Src.Tiles.*;

  public class Game
  {    
    private var IS_FINAL:Boolean = false;

    public static var STATE_GAME:int = 0;
    public static var STATE_EDITING:int = 1;
    public static var STATE_FE:int = 2;
    
	public var stage:Stage;

    private var fps:Number=60;
    private var lastTime:int = 0;
    private var fpsText:TextField;

    private var updateTracker:Number = 0;
	private var physTime:Number;

    private var gameState:int = STATE_GAME;

    public var entityManager:EntityManager;
    public var input:Input;
    public var renderer:Renderer;
    public var soundManager:SoundManager;
    public var tileMap:TileMap;
    public var mapStore:MapStore;
    public var renderTileMap:TileMap;
    public var oldRenderTileMap:TileMap;
    public var tileEditor:TileEditor;
    public var frontEnd:Frontend;
    public var camera:Camera;
    
    public static var TRANSITION_SPEED:Number = 0.15;
    public var transition:Number;
    
    [Embed(source="../level/level.lev", mimeType="application/octet-stream")]
		public static const Level: Class;	

    public function Game()
    {	  
      entityManager = new EntityManager(this, 8);
      input = new Input(this);
      renderer = new Renderer();	  
      soundManager = new SoundManager();
      renderTileMap = new TileMap(this);
      oldRenderTileMap = new TileMap(this);
      mapStore = new MapStore(this);
      mapStore.increment(); // populate tilemap
      var byteArray:ByteArray = new Level as ByteArray;
      byteArray.uncompress();
      mapStore.unserialise(byteArray);
      frontEnd = new Frontend(this);
      camera = new Camera(this);
      transition = 0;
    }

    public function init(w:int, h:int, pixelSize:int, targetFps:int, stage:Stage):void
    {
      this.stage = stage;	  
	  
      physTime = 1000.0/targetFps;
      renderer.init(w, h, pixelSize);
      soundManager.init();
      input.init();
      tileEditor = new TileEditor(tileMap);

      gameState = STATE_GAME;
      frontEnd.addScreen(new MainMenu());

      fpsText = new TextField();
      fpsText.textColor = 0xffffffff;
      fpsText.text = "352 fps";

      resetEntities();
	  
      stage.addEventListener(Event.ENTER_FRAME, enterFrame);
    }
    
    private function debugKeys():void
    {
      if(input.keyPressedDictionary[Input.KEY_E])
      {
        if(gameState == STATE_GAME)
          changeState(STATE_EDITING);
        else
          changeState(STATE_GAME);
        resetEntities();
      }
      
      if(input.keyPressedDictionary[Input.KEY_0])
        mapStore.increment();
      if(input.keyPressedDictionary[Input.KEY_9])
        mapStore.decrement();
        
      if(input.keyPressedDictionary[Input.KEY_M])
        entityManager.shouldRenderColliders = !entityManager.shouldRenderColliders;
    }

    private function update():void
    {
      camera.update();
      renderer.update();
      entityManager.update();
      if(gameState == STATE_FE)
        frontEnd.update();
      if(gameState == STATE_EDITING)
        tileEditor.update();
        
      if(transition < 1)
        transition += TRANSITION_SPEED;
      else
        transition = 1;
        
      if(!IS_FINAL)
        debugKeys();
      
        
      // Update input last, so mouse presses etc. will register first..
      // also note this mode of operation isn't perfect, sometimes input
      // will be lost!        
      input.update(); 
    }
    
    private function resetEntities(persist:Boolean=false):void
    {
      var i:int;
      var woman:Woman = null;
      var persisted:Array = null;
      if(persist)
      {
        persisted = new Array();
        for(i=0; i<entityManager.entities.length; i++)
        {
          var e:Entity = entityManager.entities[i];
          if(e is Woman || e is Ball /*|| e is Spinner TODO: Revist */)
            persisted.push(e);
        }
      }
      
      entityManager.reset();
      if(persisted)
        for(i=0; i<persisted.length; i++)
          entityManager.push(persisted[i]);
          
      if(gameState == STATE_GAME)
        tileMap.spawnEntities();
      tileMap.copyToRenderTileMap(renderTileMap);
    }

    private function render():void
    {
      renderer.cls();
	  
      renderer.setCamera(camera);
      if(gameState == STATE_EDITING)
        tileMap.render();
      else
        renderTileMap.render(0,transition,oldRenderTileMap);
      entityManager.render();
      renderer.setCamera();
      if(gameState == STATE_EDITING)
        tileEditor.render();      
      if(gameState == STATE_FE)
        frontEnd.render();
		
      if(false && !IS_FINAL)
        renderer.backBuffer.draw(fpsText);
	  
      renderer.flip();
    }

    public function enterFrame(event:Event):void
    {
      var thisTime:int = getTimer();
      fps = (fps*9 + 1000/(thisTime-lastTime))/10;
      updateTracker += thisTime-lastTime;
      lastTime = thisTime;
      if(false && fpsText)
        fpsText.text = "FPS: "+int(fps);

      while(updateTracker > 0)
      {
        update();
        updateTracker -= physTime;
      }

      if(renderer)
      {
        render();
      }
    }

    public function getState():int
    {
      return gameState;
    }

    public function changeState(state:int):void
    {
      gameState = state;
    }
    
    public function swapTileMap(tileMap:TileMap):void
    {
      if(this.tileMap)
        this.tileMap.copyToRenderTileMap(oldRenderTileMap);
      this.tileMap = tileMap;
      this.tileMap.copyToRenderTileMap(renderTileMap);
      if(tileEditor)
        tileEditor.tileMap = this.tileMap;
      resetEntities(true);
      transition = 0;
    }
  }
}