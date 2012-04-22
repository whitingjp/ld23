package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class MapAdvancer extends Entity
  {
    public var collider:CCollider;
    public var sprite:CSprite;
    public var fallIn:CFallIn;

    public function MapAdvancer(pos:Point)
    {
      sprite = new CSprite(this, "mapadvancer");
      collider = new CCollider(this);
      fallIn = new CFallIn(sprite, pos);
      reset();
      collider.pos = pos;
      collider.pos.y += 4;      
    }

    public function reset():void
    {
      sprite.xframe = 0;
      collider.pos = new Point(0,0);
      collider.speed = new Point(0,0);
      collider.rect = new Rectangle(3,7,4,4);
    }
    
    public override function update():void
    {
      fallIn.update();
    }
    
    public override function render():void
    {
      if(!fallIn.isDone())
        fallIn.render();
      else
        sprite.render(collider.pos, -9);
    }
  }
}