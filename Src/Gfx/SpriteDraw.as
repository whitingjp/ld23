package Src.Gfx
{
  public class SpriteDraw
  {
    public var sprite:String;
    public var x:int;
    public var y:int;
    public var xFrame:int;
    public var yFrame:int;
    public var layer:Number;
    
    public function SpriteDraw(sprite:String, x:int, y:int,
                                xFrame:int, yFrame:int, layer:Number)
    {
      this.sprite=sprite;
      this.x=x;
      this.y=y;
      this.xFrame=xFrame;
      this.yFrame=yFrame;
      this.layer=layer;
    }
  }  
}