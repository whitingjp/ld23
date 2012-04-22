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
      game.soundManager.playSound("increment");
    }
    
    public function decrement():void
    {
      if(current > 0)
        current--;
      game.soundManager.playSound("decrement");
    }
    
    public function cut():void
    {
      tileMaps.splice(current, 1);
    }
    
    public function serialise(byteArray:ByteArray):void
    {
      byteArray.writeInt(TileMap.magic);
      byteArray.writeInt(TileMap.version);
      byteArray.writeInt(tileMaps.length);
      for(var mapIndex:int=0; mapIndex<tileMaps.length; mapIndex++)
      {
        var tileMap:TileMap = tileMaps[mapIndex];
        byteArray.writeInt(tileMap.width);
        byteArray.writeInt(tileMap.height);
        for(var i:int=0; i<tileMap.tiles.length; i++)
          tileMap.tiles[i].addToByteArray(byteArray);
      }
    }
    
    public function unserialise(byteArray:ByteArray):void
    {      
      if(TileMap.magic != byteArray.readInt())
      {
        trace("Not a game level file!");
        return;
      }
      if(TileMap.version != byteArray.readInt())
      {
        trace("Wrong level version!");
        return;
      }
      reset();
      var len:int = byteArray.readInt();
      for(var mapIndex:int=0; mapIndex<len; mapIndex++)
      {
        game.mapStore.increment(); 
        var w:int = byteArray.readInt();
        var h:int = byteArray.readInt();        
        var tileMap:TileMap = tileMaps[mapIndex];        
        tileMap.reset(w, h);
        for(var i:int=0; i<tileMap.tiles.length; i++)
          tileMap.tiles[i].readFromByteArray(byteArray);
      }
      current = 0;
    }
  }
}