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
    private static const OBJ_SLUG:int=3;
  
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
        {
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
            case OBJ_SLUG:
              game.entityManager.push(new Slug(p));
          }
        }
        if(tiles[i].t == Tile.T_WALL && tiles[i].xFrame==1)
          game.entityManager.push(new NonPlayer(p));
        if(tiles[i].t == Tile.T_WALL && tiles[i].xFrame==2)
          game.entityManager.push(new Target(p));
      }
    }
    
    public function render_tile(tile:Tile, x:int, y:int, layer:Number):void
    {
      if(tile.t == Tile.T_WALL)
      {
        game.renderer.drawSprite(sprites[0], x, y, layer, 0, 0);
        game.renderer.drawSprite(sprites[tile.t], x, y, layer+tileHeight+tileHeight/4, tile.xFrame, tile.yFrame);
      }
      game.renderer.drawSprite(sprites[tile.t], x, y, layer, tile.xFrame, tile.yFrame);
    }
    
    public function render_transition_tile(tile:Tile, old:Tile, x:int, y:int, transition:Number, layer:Number):void
    {      
      if(transition < 1)
      {
        var xFrame:int=-1;
        var yFrame:int=-1;
        if(tile.t == Tile.T_WALL && old.t == Tile.T_NONE)
        {
          xFrame = transition*5;
          yFrame = tile.xFrame;
        }
        else if(tile.t == Tile.T_NONE && old.t == Tile.T_WALL)
        {
          xFrame = 4-transition*5;
          yFrame = old.xFrame;
        }
        if(tile.t == Tile.T_WALL && old.t == Tile.T_WALL && tile.xFrame != old.xFrame)
        {
          // transition between two wall types
          if(transition < 0.5)
          {
            xFrame = 4-transition*10;
            yFrame = old.xFrame;
          } else
          {
            xFrame = (transition-0.5)*10;
            yFrame = tile.xFrame;
          }
        }
        if(xFrame != -1)
        {
          game.renderer.drawSprite(sprites[0], x, y, layer, 0, 0);
          game.renderer.drawSprite("walltransition", x, y, layer+tileHeight/4, xFrame, yFrame);
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
        var layer:Number = y*tileHeight-tileHeight+layerOffset;
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
      var tile:Tile = getTileAtPos(p);
      switch(tile.t)
      {
        case Tile.T_WALL: 
          if(tile.xFrame == 1)
          {
            if(NonPlayer.allActive)
              return CCollider.COL_NONE;
            else
              return CCollider.COL_NOPLAYER;
          }
          else
            return CCollider.COL_SOLID;
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