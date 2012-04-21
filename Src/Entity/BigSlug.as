package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.display.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class BigSlug extends Entity
  {
    public var collider:CCollider;
    public var srcBitmap:BitmapData=null;
    public var eyeBitmap:BitmapData=null;
    public var dstBitmap:BitmapData;
    public var anim:Number;
    public var renderOff:Point;

    public function BigSlug(pos:Point)
    {      
      collider = new CCollider(this);
      reset();
      collider.pos = pos;      
      dstBitmap = new BitmapData(40,30,true,0x00000000);      
    }

    public function reset():void
    {
      collider.pos = new Point(0,0);
      collider.speed = new Point(0,0);
      collider.rect = new Rectangle(1,4,28,10);
      anim = 0;
      renderOff = new Point(0,0);
    }
    
    public function updateWobble():void
    {
      anim+=0.01;
      if(!srcBitmap)
      {
        srcBitmap = new BitmapData(30,18,true);
        eyeBitmap = new BitmapData(30,18,true);
        game.renderer.doActualSpriteDraw(srcBitmap, "bigslug", 0, 0);
        game.renderer.doActualSpriteDraw(eyeBitmap, "bigslug", 0, 0, 1);
      }
      
      var matrix:Matrix = new Matrix();
      var xwob:Number = (Math.sin(anim*5)+1)/20+1;
      var ywob:Number = (Math.sin(anim*7)+1)/20+1;
      var eyewob:Number = (Math.sin(anim*3)+1)*4;
      matrix.scale(xwob, ywob);
      renderOff.x = xwob*30-30;
      renderOff.y = ywob*18-18;
      dstBitmap.fillRect(dstBitmap.rect, 0x00000000);
      dstBitmap.draw(srcBitmap, matrix);
      dstBitmap.draw(eyeBitmap);
    }

    public override function update():void
    {
      collider.process();
      updateWobble();
      collider.clean();
    }    
	
    public override function subUpdate(subMoves:int):void
    {
      collider.subUpdate(subMoves);
    }
    
    public override function render():void
    {
      game.renderer.drawGraphic(dstBitmap, collider.pos.x-renderOff.x, collider.pos.y-renderOff.y, collider.pos.y+6);
    }
  }
}