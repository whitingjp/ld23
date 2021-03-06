package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class CSprite
  {
    public var e:Entity;
    public var sprite:String;
    public var xframe:int;
    public var yframe:int;
    
    public function CSprite(e:Entity, sprite:String)
    {
      this.e = e;
      this.sprite = sprite;
      
      xframe = 0;
      yframe = 0;
    }
    
    public function render(pos:Point, layerOffset:Number=0):void
    {
      e.game.renderer.drawSprite(sprite, pos.x, pos.y, pos.y+layerOffset, xframe, yframe);
    }
  }
}