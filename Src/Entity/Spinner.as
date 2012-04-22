package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class Spinner extends Entity
  {
    public var collider:CCollider;
    public var sprite:CSprite;
    public var fallIn:CFallIn;
    
    public static const SPEED:Number = 1;
    
    public var walkAnim:Number;
    public var dir:int;
  
    public function Spinner(pos:Point)
    {
      sprite = new CSprite(this, "spinner");
      collider = new CCollider(this);      
      collider.collisionMask = CCollider.COL_SOLID;
      fallIn = new CFallIn(sprite, pos);
      fallIn.timer = 20;
      reset();
      collider.pos = pos;
      dir = 1;
    }
    
    public function reset():void
    {
      sprite.xframe = 4;
      collider.pos = new Point(0,0);
      collider.speed = new Point(0,0);
      collider.rect = new Rectangle(1,6,6,4);
      walkAnim = 0;
    }

    public function updateRun():void
    {
      if(collider.collides[dir] & collider.collisionMask)
      {
        dir = (dir+1)%4;
        game.soundManager.playSound("spinnerwall");
      }
      switch(dir)
      {
        case 0: collider.speed.x=0; collider.speed.y=-SPEED; break;
        case 1: collider.speed.x=SPEED; collider.speed.y=0; break;
        case 2: collider.speed.x=0; collider.speed.y=SPEED; break;
        case 3: collider.speed.x=-SPEED; collider.speed.y=0; break;
      }
      walkAnim += 0.075;
      if(walkAnim > 1) walkAnim--;
      sprite.xframe = walkAnim*2;
    }

    public override function update():void
    {
      if(!fallIn.isDone())
      {
        fallIn.update();
        return;
      }
    
      collider.process();
      if(collider.enclosed()) // check stuck
        alive = false;
      updateRun();      
      collider.clean();
    }    
	
    public override function subUpdate(subMoves:int):void
    {
      collider.subUpdate(subMoves);
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