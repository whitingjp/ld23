package {
	import flash.display.Sprite;
	import flash.events.Event;
	
	import Src.Game;
	
	public class Main extends Sprite {
		private var game:Game;
	
		public function Main()
		{
			game = new Game();
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		private function onAddedToStage( pEvent : Event ) : void
		{
      if(game.IS_FINAL)
      {
        var currentDomain:String = stage.loaderInfo.url.split("/")[2];
        if(currentDomain != "jonathanwhiting.com")
          return;
          
        // MochiBot.com -- Version 8
        // Tested with Flash 9-10, ActionScript 3
        MochiBot.track(this, "e465f550");
      }      
      
			game.init( 90, 90, 6, 60, stage);
			addChild(game.renderer.bitmap);
		}
	}
}