package Src.Tiles
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.net.*;
  import flash.events.*;
  import flash.utils.*;
  import Src.*;
  import Src.Entity.*;
  import Src.Gfx.*;

  public class TileMap
  {  
    private static const OBJ_START:int=0;
    private static const OBJ_MAPADVANCER:int=1;
    private static const OBJ_BALL:int=2;
  
    public static var tileWidth:int=10;
    public static var tileHeight:int=10;
    
    private static var tileSpr:String="walls";
    private static var objSpr:String="objects";    
    
    public static const magic:int=0xface;
    public static const version:int=2;    
    
    public var width:int;
    public var height:int;
    public var tiles:Array;
    public var sprites:Array;
    
    public var game:Game;
    
    public function TileMap(game:Game)
    {
      reset(9,9);
      this.game = game;
    }
    
    public function reset(width:int, height:int):void
    {
      this.width = width;
      this.height = height;
      
      sprites = new Array();
      sprites[Tile.T_NONE] = "decoration";
      sprites[Tile.T_WALL] = "walls";
      sprites[Tile.T_ENTITY] = "objects";
      
      tiles = new Array();
      var i:int;
      for(i=0; i<width*height; i++)
          tiles.push(new Tile());
          
      for(i=0; i<width; i++)
      {
        tiles[getIndex(i,0)].t = Tile.T_WALL;
        tiles[getIndex(i,height-1)].t = Tile.T_WALL;
      }
      for(i=0; i<height; i++)
      {
        tiles[getIndex(0,i)].t = Tile.T_WALL;
        tiles[getIndex(width-1,i)].t = Tile.T_WALL;
      }      
    }
    
    public function spawnEntities():void
    {
      for(var i:int=0; i<tiles.length; i++)
      {
        var y:int = i/width;
        var x:int = i-(y*width);
        var p:Point = new Point(x*tileWidth, y*tileHeight);
        if(tiles[i].t == Tile.T_ENTITY)
        switch(tiles[i].xFrame)
        {
          case OBJ_START:
            game.entityManager.push(new Woman(p));
            break;
          case OBJ_MAPADVANCER:
            game.entityManager.push(new MapAdvancer(p));
            break;
          case OBJ_BALL:
            game.entityManager.push(new Ball(p));
            break;
        }
      }
    }
    
    public function render_tile(tile:Tile, x:int, y:int, layer:Number):void
    {
      game.renderer.drawSprite(sprites[tile.t], x, y, layer, tile.xFrame, tile.yFrame);
    }
    
    public function render_transition_tile(tile:Tile, old:Tile, x:int, y:int, transition:Number, layer:Number):void
    {      
      if(tile.t != old.t && transition < 1)
      {
        var frame:int=-1;
        if(tile.t == Tile.T_WALL && old.t == Tile.T_NONE)
          frame = transition*5;
        else if(tile.t == Tile.T_NONE && old.t == Tile.T_WALL)
          frame = 4-transition*5;
        if(frame != -1)
        {
          game.renderer.drawSprite("walltransition", x, y, layer, frame, tile.yFrame);
          return;
        }
      }
      
      // no transition code found, default to just drawing
      render_tile(tile, x, y, layer);
    }

    public function render(layerOffset:Number=0, transition:Number=1, old:TileMap=null):void
    {
      for(var i:int=0; i<tiles.length; i++)
      {
        var y:int = i/width;
        var x:int = i-(y*width);
        var tile:Tile = getTile(x,y);
        var layer:Number = y*tileHeight+layerOffset;
        if(tile.t == Tile.T_WALL) layer+=tileHeight/4;
        else layer-=tileHeight;
        if(old)
          render_transition_tile(tile, old.getTile(x,y), x*tileWidth, y*tileHeight, transition, layer);
        else
          render_tile(tile, x*tileWidth, y*tileHeight, layer);
      }
    }
    
    public function getIndex(x:int, y:int):int
    {
      while(x < 0) x+=width;
      while(x >= width) x-=width;
      while(y < 0) y+=height;
      while(y >= height) y-=height;
      return x+y*width;
    }
    
    public function getIndexFromPos(p:Point):int
    {
      var iTileX:int = p.x / tileWidth;
      var iTileY:int = p.y / tileHeight;
      return getIndex(iTileX, iTileY);
    }
    
    public function getTileFromIndex(i:int):Tile
    {
      return tiles[i];
    }    
        
    public function getTile(x:int, y:int):Tile
    {
      return getTileFromIndex(getIndex(x,y));
    }
    
    public function getTileAtPos(p:Point):Tile
    {
      return getTileFromIndex(getIndexFromPos(p));
    }

    public function getXY(i:int):Point
    {
      var y:int = i/width;
      var x:int = i-(y*width);
      return new Point(x,y);
    }
    
    public function setTileByIndex(i:int, tile:Tile):void
    {
      tiles[i] = tile.clone();
    }
    
    public function setTile(x:int, y:int, tile:Tile):void
    {
      setTileByIndex(getIndex(x,y), tile);
    }
    
    public function getColAtPos(p:Point):int
    {
      switch(getTileAtPos(p).t)
      {
        case Tile.T_WALL: return CCollider.COL_SOLID;
      }
      return CCollider.COL_NONE;
    }
    
    public function copyToRenderTileMap(renderTileMap:TileMap):void
    {
      for(var i:int=0; i<tiles.length; i++)
      {
        var tile:Tile = tiles[i].clone();
        if(tile.t == Tile.T_ENTITY)
        {
          tile.t = Tile.T_NONE;
          tile.xFrame = 0;
        }
        renderTileMap.setTileByIndex(i, tile);
      }
    }
  }
}