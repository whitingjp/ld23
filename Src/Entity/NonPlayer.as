package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class NonPlayer extends Entity
  {
    public static const ACTIVE_TIME:int = 60*5;
  
    public var collider:CCollider;
    public var sprite:CSprite;
    public static var allActive:Boolean;

    public function NonPlayer(pos:Point)
    {
      sprite = new CSprite(this, "nonplayer");
      collider = new CCollider(this);
      reset();
      collider.pos = pos;
      allActive = false;
    }

    public function reset():void
    {
      sprite.xframe = 0;
      collider.pos = new Point(0,0);
    }

    public override function update():void
    {
      allActive = true;
      for(var i:int = 0; i<game.entityManager.entities.length; i++)
      {
        var e:Entity = game.entityManager.entities[i];
        if(e is Target)
          if(!Target(e).activeTimer) allActive = false;
      }      
    }
    
    public override function render():void
    {
      if(game.transition < 1) return;
      sprite.xframe = allActive ? 1 : 0;
      sprite.render(collider.pos, TileMap.tileHeight/4+1);
    }
  }
}