package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class CFallIn
  {
    private var sprite:CSprite
    private var dest:Point;
    private var shadowSprite:String;
    
    public var timer:int=20;
    
    public function CFallIn(sprite:CSprite, dest:Point, shadowSprite:String="shadow")
    {
      this.sprite = sprite;
      this.dest = dest;
      this.shadowSprite = shadowSprite;
      timer = 15+Math.random()*10;
    }
    
    public function update():void
    {
      if(timer > 0) timer--;
    }
    
    public function render():void
    {
      var renderPos:Point = dest.clone();
      var progress:Number = Number(timer)/20;
      renderPos.y -= 90*progress;
      sprite.render(renderPos, 100);
      sprite.e.game.renderer.drawSprite(shadowSprite, dest.x, dest.y, dest.y);
    }
    
    public function isDone():Boolean
    {
      return timer==0;
    }
  }
}