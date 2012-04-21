package Src.Tiles
{
  import flash.utils.*;
  import Src.*;
  public class MapStore
  {
    private var game:Game;
    public var tileMaps:Array;
    public var _current:int;
    
    public function MapStore(game:Game)
    {
      this.game = game;
      reset();
    }
    
    public function reset():void
    {
      tileMaps = new Array();
      _current = -1;
    }
    
    public function get current():int
    {
      return _current;
    }
    
    public function set current(value:int):void
    {
      _current = value;
      game.swapTileMap(tileMaps[current]);
    }
        
    public function increment():void
    {
      if(current == tileMaps.length-1)
        tileMaps.push(new TileMap(game));
      current++;
    }
    
    public function decrement():void
    {
      if(current > 0) current--;
    }
  }
}