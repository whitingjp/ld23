package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.display.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;
  import Src.*;

  public class Snake extends Entity
  {
    public var pieces:Array;
    public var fallIns:Array;
    public var dir:int;
    public var timer:int=0;
    public var health:int=14;
    public var announced:Boolean=false;
    public var ready:Boolean=false;
    public var dying:Boolean=false;
    public var hurtTimer:int;
    
    public function Snake(pos:Point)
    {
      pieces = new Array();
      fallIns = new Array();
      dir = 1;
      for(var i:int=0; i<13; i++)
      {
        var col:CCollider = new CCollider(this);
        col.pos = pos.clone();
        col.pos.x += i*3;
        col.pos.y += Math.sin(Number(i)/2)*2;
        col.rect = new Rectangle(2,6,6,6);
        col.speed = new Point(0,0);
        pieces.push(col);
        
        var sprite:CSprite = new CSprite(this, "snake");
        if(i==12) sprite.xframe=1;
        var fallIn:CFallIn = new CFallIn(sprite, col.pos);
        fallIns.push(fallIn);
      }
      hurtTimer = 0;
    }
    
    public function updateHurt():void
    {
      if(hurtTimer)
        return;
      for(var i:int = 0; i<game.entityManager.entities.length; i++)
      {
        var e:Entity = game.entityManager.entities[i];
        var j:int;
        for(j = 0; j<pieces.length; j++)
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
            hurt();
            e.alive = false;
            if(health)
              newDestroyer();
          } 
        }
        if(e is Ball)
        {
          for(j= 0; j<pieces.length-1; j++)
          {
            if(pieces[j].intersects(Ball(e).collider))
            {
              Ball(e).collider.speed.x *= -1;
              Ball(e).collider.speed.y *= -1;
            }
          }
          if(pieces[pieces.length-1].intersects(Ball(e).collider))
            hurt();
        }
      }
    }
    
    public function newDestroyer():void
    {
      var woman:Woman = Woman(game.entityManager.findEntityOfClass(Woman));
      if(!woman) return;
      var p:Point = woman.collider.pos;
      var sqrDist:Number = 0;
      var pos:Point = new Point();
      while(sqrDist < 200)
      {
        pos.x = (Math.random()*4+2)*10;
        pos.y = (Math.random()*4+2)*10;
        sqrDist = (pos.x-p.x)*(pos.x-p.x) + (pos.y-p.y)*(pos.y-p.y);
      }
      game.entityManager.push(new Destroyer(pos));
    }
    
    public function hurt():void
    {
      // hurt
      game.soundManager.playSound("hitmonster");
      health--;      
      if(!health)
        dying = true;
      hurtTimer = 30;
    }
    
    public function updateFallIns():void
    {
      ready = true;
      for(var i:int = 0; i<fallIns.length; i++)
      {
        fallIns[i].update();
        if(!fallIns[i].isDone())
          ready = false;
      }
    }
    
    public function updateDying():void
    {
      if(!timer)
      {
        game.soundManager.playSound("hitmonster");
        var piece:CCollider = pieces.shift();
        Particle.spawnBurst(game.entityManager, piece.pos, "particle", pieces.length == 0 ? 1 : 2);
        timer = 10;
        if(pieces.length == 0)
        {
          game.mapStore.increment();
          Game.so.data.current = game.mapStore.current;
          Game.so.flush();     
          return;
        }        
      } else
      {
        timer--;
      }
    }
    
    public override function update():void
    {
      if(!ready)
      {
        updateFallIns();
        return;
      }
      
      if(dying)
      {
        updateDying();
        return;
      }
    
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
      if(hurtTimer)
        hurtTimer--;
      else
        timer--;
      
      updateHurt();
    }
    
    public override function render():void
    {
      var i:int;
      if(!ready)
      {
        for(i=0; i<fallIns.length; i++)
        {
          fallIns[i].render();
        }
      } else
      {    
        for(i=0; i<pieces.length; i++)
        {
          var xFrame:int = 0;
          if(i==pieces.length-1)
            xFrame = (hurtTimer/4)%2+1;
          var layerOffset:Number= Number(i)/pieces.length;
          game.renderer.drawSprite("snake", pieces[i].pos.x, pieces[i].pos.y, pieces[i].pos.y+layerOffset, xFrame);
        }
      }
    }
  }
}