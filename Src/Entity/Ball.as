package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;
  import Src.*;

  public class Ball extends Entity
  {
    public var collider:CCollider;
    public var sprite:CSprite;
    public var fallIn:CFallIn;
    public var moving:Boolean;
    public var grabbedTimer:int;
    public var bounceSoundTimer:int;

    public function Ball(pos:Point)
    {      
      sprite = new CSprite(this, "ball");
      collider = new CCollider(this);
      fallIn = new CFallIn(sprite, pos);
      collider.elasticity = 0.7;
      reset();
      collider.pos = pos;
    }

    public function reset():void
    {
      sprite.xframe = 0;
      collider.pos = new Point(0,0);
      collider.speed = new Point(0,0);
      collider.rect = new Rectangle(0,4,9,8);
      grabbedTimer = 0;
      bounceSoundTimer = 0;
    }
    
    public function updateMove():void
    {
      for(var i:int = 0; i<game.entityManager.entities.length; i++)
      {
        var e:Entity = game.entityManager.entities[i];
        if(e is Woman)
        {
          var woman:Woman = Woman(e);
          if(collider.intersects(woman.collider))
          {
            collider.speed.x *= 0.5;
            collider.speed.y *= 0.5;
            collider.speed.x += woman.collider.speed.x;
            collider.speed.y += woman.collider.speed.y;
            if(grabbedTimer == 0)
              game.soundManager.playSound("ballpickup");
            grabbedTimer = 30;
          }
        }
        if(e is Slug)
        {
          var slug:Slug = Slug(e);
          if(collider.intersects(slug.collider))
          {
            collider.speed.x *= -1;
            collider.speed.y *= -1;
            slug.alive = false;
            Particle.spawnBurst(game.entityManager, collider.pos, "particle", 0);
            playBounceSound();
            game.soundManager.playSound("hitmonster");
          }
        }
        if(e is Spinner)
        {
          if(collider.intersects(Spinner(e).collider))
          {
            collider.speed.x *= -1;
            collider.speed.y *= -1;
            e.alive = false;
            Particle.spawnBurst(game.entityManager, collider.pos, "particle", 0);
            playBounceSound();
            game.soundManager.playSound("hitmonster");
          }
        }
        if(e is BigSlug)
        {
          var bigslug:BigSlug = BigSlug(e);
          if(collider.intersects(bigslug.collider))
          {
            collider.speed.y += 0.05;
            bigslug.hurt();
          }          
        }
      }
    }
    
    public function playBounceSound():void
    {
      if(bounceSoundTimer > 0) return;
      game.soundManager.playSound("bounceball");
      bounceSoundTimer = 10;
    }
    
    public function updateBounce():void
    {
      var bounced:Boolean=false
      for(var i:int=0; i<4; i++)
        if(collider.collides[i] & collider.collisionMask)
          playBounceSound();
    }
    
    public override function update():void
    {
      if(!fallIn.isDone())
      {
        fallIn.update();
        return;
      }
    
      if(bounceSoundTimer) bounceSoundTimer--;
      if(grabbedTimer) grabbedTimer--;
    
      collider.process();
      
      updateBounce();
      if(collider.enclosed()) // check stuck
        alive = false;
      updateMove();
      collider.clean();
    }
    
    public override function subUpdate(subMoves:int):void
    {
      collider.subUpdate(subMoves);
    }

    public override function render():void
    {
      if(!fallIn.isDone())
        fallIn.render();
      else
        sprite.render(collider.pos);
    }    
  }
}