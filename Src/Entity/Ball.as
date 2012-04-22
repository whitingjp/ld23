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
    public var moving:Boolean;

    public function Ball(pos:Point)
    {      
      sprite = new CSprite(this, "ball");
      collider = new CCollider(this);
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
          }
        }
        if(e is Spinner)
        {
          if(collider.intersects(Spinner(e).collider))
          {
            collider.speed.x *= -1;
            collider.speed.y *= -1;
            e.alive = false;
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
    
    public override function update():void
    {
      collider.process();
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
      sprite.render(collider.pos);
    }    
  }
}