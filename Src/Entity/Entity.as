package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*;
  import Src.*;

  public class Entity
  {
    public var alive:Boolean;
    private var manager:EntityManager;
    public var type:String;

    public function Entity()
    {
      alive = true;
    }

    public function setManager(manager:EntityManager):void
    {
      this.manager = manager;
    }
    
    public function get game():Game
    {
      return manager.game;
    }    

    public function update():void {}
    public function subUpdate(subMoves:int):void {}
    public function render():void {}
  }
}