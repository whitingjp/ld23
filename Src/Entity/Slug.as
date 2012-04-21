package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class Slug extends Entity
  {
    public var collider:CCollider;
    public var sprite:CSprite;
    
    public var walkAnim:Number;

    public function Slug(pos:Point)
    {      
      sprite = new CSprite(this, "slug");
      collider = new CCollider(this);
      collider.collisionMask = CCollider.COL_SOLID;
      reset();
      collider.pos = pos;      
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
      var woman:Woman = Woman(game.entityManager.findEntityOfClass(Woman));
      if(woman)
      {
        var diff:Point = new Point(collider.pos.x - woman.collider.pos.x, 
                                    collider.pos.y - woman.collider.pos.y);
        var distance:Number = Math.sqrt(diff.x*diff.x+diff.y*diff.y);
        diff.x /= distance;
        diff.y /= distance;
        collider.speed.x = -0.1*diff.x;
        collider.speed.y = -0.1*diff.y;
      }
      walkAnim += 0.05;
      if(walkAnim > 1) walkAnim--;
      sprite.xframe = walkAnim*2;
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