package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class Target extends Entity
  {
    public static const ACTIVE_TIME:int = 60*11;
  
    public var collider:CCollider;
    public var sprite:CSprite;
    public var activeTimer:int;

    public function Target(pos:Point)
    {
      sprite = new CSprite(this, "target");
      collider = new CCollider(this);
      reset();
      collider.pos = pos;
      collider.pos.y+=4;      
    }

    public function reset():void
    {
      sprite.xframe = 0;
      collider.pos = new Point(0,0);
      collider.speed = new Point(0,0);
      collider.rect = new Rectangle(-1,-1,11,11);
    }

    public override function update():void
    {
      var allActive:Boolean = true;
      for(var i:int = 0; i<game.entityManager.entities.length; i++)
      {
        var e:Entity = game.entityManager.entities[i];
        var c:CCollider = null;
        if(e is Woman) c = Woman(e).collider;
        if(e is Ball) c = Ball(e).collider;
        if(c)
        {
          if(collider.intersects(c))
          {
            if(activeTimer == 0)
              game.soundManager.playSound("hittarget");
            activeTimer = ACTIVE_TIME;
          }
        }
        if(e is Target)
        {
          if(!Target(e).activeTimer) allActive = false;
        }
      }
      if(!allActive && activeTimer)
        activeTimer--;
    }
    
    public override function render():void
    {
      if(game.transition < 1) return;
      sprite.xframe = activeTimer > 0 ? 1 : 0;
      sprite.render(collider.pos, TileMap.tileHeight/4+1);
    }
  }
}