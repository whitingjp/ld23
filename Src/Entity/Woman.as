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

    public function Woman(pos:Point)
    {      
      sprite = new CSprite(this, "player");
      collider = new CCollider(this);
      reset();
      collider.pos = pos;      
    }

    public function reset():void
    {
      sprite.frame = 0;
      collider.pos = new Point(0,0);
      collider.speed = new Point(0,0);
      collider.rect = new Rectangle(2,8,6,4);
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
        collider.speed.x /= 1.5;
      if(!game.input.upKey() && !game.input.downKey())
        collider.speed.y /= 1.5;
    }

    public override function update():void
    {
      collider.process();
      updateRun();
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