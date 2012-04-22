package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class Destroyer extends Entity
  {
    public var collider:CCollider;
    public var sprite:CSprite;
    public var fallIn:CFallIn;
    
    public var anim:Number=0;
    
    public function Destroyer(pos:Point)
    {
      sprite = new CSprite(this, "destroyer");
      collider = new CCollider(this);
      fallIn = new CFallIn(sprite, pos);
      reset();
      collider.pos = pos;
      collider.pos.y+=4;
    }
    
    public function reset():void
    {
      collider.pos = new Point(0,0);
      collider.speed = new Point(0,0);
      collider.rect = new Rectangle(3,7,4,4);
    }
    
    public override function update():void
    {
      if(!fallIn.isDone())
      {
        fallIn.update();
        return;
      }
    
      for(var i:int = 0; i<game.entityManager.entities.length; i++)
      {
        var e:Entity = game.entityManager.entities[i];
        var c:CCollider = null;
        if(e is Ball) c = Ball(e).collider;
        if(e is Slug) c = Slug(e).collider;
        if(e is Spinner) c = Spinner(e).collider;
        if(c && collider.intersects(c))
        {
          e.alive = false;
          game.soundManager.playSound("destroy");
          Particle.spawnBurst(game.entityManager, c.pos, "particle", 0);
        }
      }
      anim += 0.05;
      if(anim > 1) anim--;
      sprite.xframe = anim*2;
    }
    
    public override function render():void
    {
      if(!fallIn.isDone())
        fallIn.render();
      else
        sprite.render(collider.pos);
    }    
  }
}