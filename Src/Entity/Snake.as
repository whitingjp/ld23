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
    public var health:int=14;
    public var announced:Boolean=false;
    
    public function Snake(pos:Point)
    {
      pieces = new Array();
      dir = 1;
      for(var i:int=0; i<13; i++)
      {
        var col:CCollider = new CCollider(this);
        col.pos = pos.clone();
        col.rect = new Rectangle(2,6,6,6);
        col.speed = new Point(0,0);
        pieces.push(col);
      }
    }
    
    public function updateHurt():void
    {
      for(var i:int = 0; i<game.entityManager.entities.length; i++)
      {
        var e:Entity = game.entityManager.entities[i];
        for(var j:int = 0; j<pieces.length; j++)
        {          
          if(e is Woman)
          {
            if(pieces[j].intersects(Woman(e).collider))
            {
              game.mapStore.decrement();
              return;
            }
          }
        }
        
        if(e is Destroyer)
        {
          if(pieces[pieces.length-1].intersects(Destroyer(e).collider))
          {
            // hurt
            game.soundManager.playSound("hitmonster");
            health--;
            e.alive = false;
            if(health)
            {
              var xp:int = Math.random()*4+2;
              var yp:int = Math.random()*4+2;
              var pos:Point = new Point(xp*10, yp*10);
              game.entityManager.push(new Destroyer(pos));
            } else
            {
              game.mapStore.increment();
              return;
            }
          }
        }
      }
    }
    
    public override function update():void
    {
      if(!announced)
      {
        game.soundManager.playSound("bossappear");
        announced = true;
      }
    
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
          var speed:Number = (1-(health/7.0))*1.5+3;
          col.pos.x = head.pos.x-diff.x*speed;
          col.pos.y = head.pos.y-diff.y*speed;
        }
        pieces.push(col);
      }      
      timer--;
      
      updateHurt();
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