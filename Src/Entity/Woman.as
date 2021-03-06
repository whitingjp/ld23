package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;
  import Src.*;

  public class Woman extends Entity
  {
    public var collider:CCollider;
    public var sprite:CSprite;
    public var fallIn:CFallIn;
    
    public var walkAnim:Number;

    public function Woman(pos:Point)
    {      
      sprite = new CSprite(this, "player");
      collider = new CCollider(this);
      fallIn = new CFallIn(sprite, pos);
      collider.collisionMask = CCollider.COL_SOLID | CCollider.COL_NOPLAYER;
      reset();
      collider.pos = pos;      
    }

    public function reset():void
    {
      sprite.xframe = 4;
      collider.pos = new Point(0,0);
      collider.speed = new Point(0,0);
      collider.rect = new Rectangle(0,5,8,6);
      walkAnim = 0;
    }

    public function updateRun():void
    {
      if(game.input.leftKey())
      {
        collider.speed.x -= 0.15;
        if(collider.speed.x < -1)
          collider.speed.x = -1;
      }
      if(game.input.rightKey())
      {
        collider.speed.x += 0.15;
        if(collider.speed.x > 1)
          collider.speed.x = 1;
      }
      if(game.input.upKey())
      {
        collider.speed.y -= 0.15;
        if(collider.speed.y < -1)
          collider.speed.y = -1;
      }
      if(game.input.downKey())
      {
        collider.speed.y += 0.15;
        if(collider.speed.y > 1)
          collider.speed.y = 1;
      }
      if(!game.input.leftKey() && !game.input.rightKey())
        collider.speed.x /= 2;
      if(!game.input.upKey() && !game.input.downKey())
        collider.speed.y /= 2;
        
      if(game.input.keyDownDictionary[Input.KEY_SHIFT])
        collider.collisionMask = 0;
      else
        collider.collisionMask = CCollider.COL_SOLID | CCollider.COL_NOPLAYER;
    }
    
    public function updateEntityCollision():void
    {
      for(var i:int = 0; i<game.entityManager.entities.length; i++)
      {
        var e:Entity = game.entityManager.entities[i];
        if(e is MapAdvancer)
        {
          var ma:MapAdvancer = MapAdvancer(e);
          if(collider.intersects(ma.collider) && game.transition == 1)
          {
            collider.pos = ma.collider.pos.clone();
            collider.pos.y -= 4;
            game.mapStore.increment(); // this resets entities
            Game.so.data.current = game.mapStore.current;
            Game.so.flush();     
            return;
          }
        }
        var c:CCollider = null;
        if(e is Destroyer) c = Destroyer(e).collider;
        if(e is Slug) c = Slug(e).collider;
        if(e is Spinner) c = Spinner(e).collider;
        if(c && collider.intersects(c) && game.transition == 1)
        {
          game.mapStore.decrement(); // this resets entities
          Game.so.data.current = game.mapStore.current;
          Game.so.flush();     
          return;
        }
      }
    }
    
    public function updateAnim():void
    {
      var xoff:int = game.input.leftKey() ? -1 : 0 + game.input.rightKey() ? 1 : 0;
      var yoff:int = game.input.upKey() ? -1 : 0 + game.input.downKey() ? 1 : 0;
      if(xoff == 0 && yoff  < 0) sprite.xframe = 0;
      if(xoff  > 0 && yoff  < 0) sprite.xframe = 1;
      if(xoff  > 0 && yoff == 0) sprite.xframe = 2;
      if(xoff  > 0 && yoff  > 0) sprite.xframe = 3;
      if(xoff == 0 && yoff  > 0) sprite.xframe = 4;
      if(xoff  < 0 && yoff  > 0) sprite.xframe = 5;
      if(xoff  < 0 && yoff == 0) sprite.xframe = 6;
      if(xoff  < 0 && yoff  < 0) sprite.xframe = 7;
      
      if(xoff != 0 || yoff != 0)
      {
        walkAnim += 0.05;
        if(walkAnim > 1) walkAnim--;
        sprite.yframe = walkAnim*2;
      }
    }

    public override function update():void
    {
      if(!fallIn.isDone())
      {
        fallIn.update();
        return;
      }
    
      collider.process();
      if(collider.enclosed()) // check stuck
        game.mapStore.decrement(); // this resets entities
      updateRun();      
      updateEntityCollision();
      updateAnim();
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