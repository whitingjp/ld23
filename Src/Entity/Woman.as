package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class Woman extends Entity
  {
    public var collider:CCollider;
    public var sprite:CSprite;
    
    public var walkAnim:Number;

    public function Woman(pos:Point)
    {      
      sprite = new CSprite(this, "player");
      collider = new CCollider(this);
      reset();
      collider.pos = pos;      
    }

    public function reset():void
    {
      sprite.xframe = 4;
      collider.pos = new Point(0,0);
      collider.speed = new Point(0,0);
      collider.rect = new Rectangle(0,6,9,4);
      walkAnim = 0;
    }

    public function updateRun():void
    {
      if(game.input.leftKey())
      {
        collider.speed.x -= 0.15;
        if(collider.speed.x < -1)
          collider.speed.x = -1;
      }
      if(game.input.rightKey())
      {
        collider.speed.x += 0.15;
        if(collider.speed.x > 1)
          collider.speed.x = 1;
      }
      if(game.input.upKey())
      {
        collider.speed.y -= 0.15;
        if(collider.speed.y < -1)
          collider.speed.y = -1;
      }
      if(game.input.downKey())
      {
        collider.speed.y += 0.15;
        if(collider.speed.y > 1)
          collider.speed.y = 1;
      }
      if(!game.input.leftKey() && !game.input.rightKey())
        collider.speed.x /= 2;
      if(!game.input.upKey() && !game.input.downKey())
        collider.speed.y /= 2;
    }
    
    public function updateEntityCollision():void
    {
      for(var i:int = 0; i<game.entityManager.entities.length; i++)
      {
        var e:Entity = game.entityManager.entities[i];
        if(e is MapAdvancer)
        {
          var ma:MapAdvancer = MapAdvancer(e);
          if(collider.intersects(ma.collider))
          {
            game.mapStore.increment(); // this resets entities
            game.entityManager.push(this); // re-add me
            return;
          }
        }
      }
    }
    
    public function updateAnim():void
    {
      var xoff:int = game.input.leftKey() ? -1 : 0 + game.input.rightKey() ? 1 : 0;
      var yoff:int = game.input.upKey() ? -1 : 0 + game.input.downKey() ? 1 : 0;
      if(xoff == 0 && yoff  < 0) sprite.xframe = 0;
      if(xoff  > 0 && yoff  < 0) sprite.xframe = 1;
      if(xoff  > 0 && yoff == 0) sprite.xframe = 2;
      if(xoff  > 0 && yoff  > 0) sprite.xframe = 3;
      if(xoff == 0 && yoff  > 0) sprite.xframe = 4;
      if(xoff  < 0 && yoff  > 0) sprite.xframe = 5;
      if(xoff  < 0 && yoff == 0) sprite.xframe = 6;
      if(xoff  < 0 && yoff  < 0) sprite.xframe = 7;
      
      if(xoff != 0 || yoff != 0)
      {
        walkAnim += 0.05;
        if(walkAnim > 1) walkAnim--;
        sprite.yframe = walkAnim*2;
      }
    }

    public override function update():void
    {
      collider.process();
      updateRun();      
      updateEntityCollision();
      updateAnim();
      collider.clean();
    }    
	
    public override function subUpdate(subMoves:int):void
    {
      collider.subUpdate(subMoves);
    }
    
    public override function render():void
    {
      sprite.render(collider.pos);
    }
  }
}