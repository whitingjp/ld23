package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;
  import Src.*;

  public class Particle extends Entity
  {
    public var collider:CCollider;
    public var sprite:CSprite;
    public var timer:int;
    
    public function Particle(pos:Point, speed:Point, sprite:String, xframe:int, yframe:int)
    {
      this.sprite = new CSprite(this, sprite);
      this.sprite.xframe = xframe;
      this.sprite.yframe = yframe;
      collider = new CCollider(this);
      collider.pos = pos.clone();
      collider.speed = speed.clone();
      collider.rect = new Rectangle(0,0,2,2);
      collider.elasticity = 0.6;
      timer = Math.random()*120;
    }
    
    public override function update():void
    {
      collider.subUpdate(1);
      collider.process();
      collider.clean();
      collider.speed.x *= 0.99;
      collider.speed.y *= 0.99;
      timer--;
      if(timer <= 0) alive = false;
    }
    
    public override function render():void
    {
      sprite.render(collider.pos);
    }
    
    public static function spawnBurst(manager:EntityManager, pos:Point, sprite:String, yframe:int):void
    {
      var num:int = Math.random()*3+3;
      var speed:Point = new Point(0,0);
      for(var i:int = 0; i<num; i++)
      {
        speed.x = (Math.random()-0.5)*4;
        speed.y = (Math.random()-0.5)*4;
        manager.push(new Particle(pos, speed, sprite, Math.random()*4, yframe));
      }
    }
  }
}
