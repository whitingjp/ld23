package Src.FE
{
  import mx.core.*;
  import mx.collections.*;
  import Src.*;
  import Src.Gfx.*;

  public class ResumeYesNo extends Screen
  {
    private static var RESUME:int = 0;
    private static var FRESH:int = 1;

    private var listMenu:ListMenu;

    public function ResumeYesNo()
    {
      listMenu = new ListMenu(this);
      listMenu.addItem("Resume");
      listMenu.addItem("Start Fresh");
    }

    public override function update():void
    {
      var itemSelected:int = listMenu.update();
      if(itemSelected == -1)
        return;

      if(itemSelected == FRESH)
      {
        game.mapStore.current = 0;
        Game.so.data.current = game.mapStore.current;
        Game.so.flush();     
      }
        
      
      game.soundManager.playSound("test");
      game.changeState(Game.STATE_GAME);
      game.resetEntities();
    }

    public override function render():void
    {
      listMenu.render();
    }
  }
}