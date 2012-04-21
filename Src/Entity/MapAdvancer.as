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

    public function MapAdvancer(pos:Point)
    {
      sprite = new CSprite(this, "mapadvancer");
      collider = new CCollider(this);
      reset();
      collider.pos = pos;      
    }

    public function reset():void
    {
      sprite.xframe = 0;
      collider.pos = new Point(0,0);
      collider.speed = new Point(0,0);
      collider.rect = new Rectangle(3,7,4,4);
    }
    
    public override function render():void
    {
      sprite.render(collider.pos, -9);
    }
  }
}