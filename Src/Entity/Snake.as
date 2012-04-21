package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.display.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class Snake extends Entity
  {
    public var pieces:Array;
    public var dir:int;
    public var timer:int=0;
    public function Snake(pos:Point)
    {
      pieces = new Array();
      dir = 1;
      for(var i:int=0; i<13; i++)
      {
        var col:CCollider = new CCollider(this);
        col.pos = pos.clone();
        col.rect = new Rectangle(1,1,6,6);
        col.speed = new Point(0,0);
        pieces.push(col);
      }
    }
    
    public override function update():void
    {
      if(!timer)
      {
        timer = 10;
        var col:CCollider = pieces.shift();
        var head:CCollider = pieces[pieces.length-1];
        
        var woman:Woman = Woman(game.entityManager.findEntityOfClass(Woman));
        if(woman)
        {          
          var diff:Point = new Point(head.pos.x - woman.collider.pos.x, 
                                    head.pos.y - woman.collider.pos.y);
          var distance:Number = Math.sqrt(diff.x*diff.x+diff.y*diff.y);
          diff.x /= distance;
          diff.y /= distance;        
          col.pos.x = head.pos.x-diff.x*4;
          col.pos.y = head.pos.y-diff.y*4;
        }
        pieces.push(col);
      }      
      timer--;
    }
    
    public override function render():void
    {
      for(var i:int=0; i<pieces.length; i++)
      {
        var xFrame:int = i==pieces.length-1 ? 1 : 0;
        var layerOffset:Number= Number(i)/pieces.length;
        game.renderer.drawSprite("snake", pieces[i].pos.x, pieces[i].pos.y, pieces[i].pos.y+layerOffset, xFrame);
      }
    }
  }
}