package Src.Gfx
{
  import mx.core.*;
  import mx.collections.*;
  import flash.display.*;
  import flash.geom.*

  public class SpriteDraw
  {
    public var sprite:String;
    public var x:int;
    public var y:int;
    public var xFrame:int;
    public var yFrame:int;
    public var layer:Number;
    public var bitmapData:BitmapData;
    
    public function SpriteDraw(sprite:String, x:int, y:int,
                                xFrame:int, yFrame:int, layer:Number,
                                bitmapData:BitmapData=null)
    {
      this.sprite=sprite;
      this.x=x;
      this.y=y;
      this.xFrame=xFrame;
      this.yFrame=yFrame;
      this.layer=layer;
      this.bitmapData=bitmapData;
    }
  }  
}