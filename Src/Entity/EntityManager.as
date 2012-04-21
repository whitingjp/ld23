package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import Src.*;
  import Src.Gfx.*;

  public class EntityManager
  {
    public var entities:Array;
    private var subMoves:int;
    public var game:Game;
    public var shouldRenderColliders:Boolean;

    public function EntityManager(game:Game, subMoves:int)
    {      
      this.game = game;
      this.subMoves = subMoves;
      reset();
    }
    
    public function reset():void
    {
      entities = new Array();
    }

    public function push(entity:Entity):void
    {
      entity.setManager(this);
      entities.push(entity);
    }

    public function update():void
    {
      var i:int;
      var j:int;
      for(j=0; j<subMoves; j++)
        for(i=0; i<entities.length; i++)
          entities[i].subUpdate(subMoves);
      for(i=0; i<entities.length; i++)
        entities[i].update();
      entities = entities.filter(isAlive);
    }
    
    public function renderColliders():void
    {
      for(var i:int=0; i<entities.length; i++)
      {
        if(entities[i].hasOwnProperty("collider"))
        {
          var collider:CCollider = CCollider(entities[i].collider);
          game.renderer.drawSprite("marker", collider.pos.x+collider.rect.x, collider.pos.y+collider.rect.y);
          game.renderer.drawSprite("marker", collider.pos.x+collider.rect.x+collider.rect.width, collider.pos.y+collider.rect.y);
          game.renderer.drawSprite("marker", collider.pos.x+collider.rect.x, collider.pos.y+collider.rect.y+collider.rect.height);
          game.renderer.drawSprite("marker", collider.pos.x+collider.rect.x+collider.rect.width, collider.pos.y+collider.rect.y+collider.rect.height);
        }
      }
    }

    public function render():void
    {      
      for(var i:int=0; i<entities.length; i++)
        entities[i].render();
      if(shouldRenderColliders)
        renderColliders();
    }

    private function isAlive(element:*, index:int, arr:Array):Boolean
    {
      return element.alive;
    }
  }
}