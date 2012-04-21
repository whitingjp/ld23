package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;
  import Src.*;

  public class BallSpawner extends Entity
  {
    public var collider:CCollider;
    public function BallSpawner(pos:Point)
    {
      collider = new CCollider(this);
      collider.elasticity = 0.7;
      reset();
      collider.pos = pos;
    }
    
    public function reset():void
    {
      collider.pos = new Point(0,0);
      collider.speed = new Point(0,0);      
    }
    
    public override function update():void
    {
      if(!game.entityManager.findEntityOfClass(Ball))
        game.entityManager.push(new Ball(collider.pos));
    }
  }
}