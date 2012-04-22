package Src.FE
{
  import mx.core.*;
  import mx.collections.*;
  import flash.display.*;
  import flash.geom.*
  import Src.*;
  import Src.Gfx.*;

  public class Splash extends Screen
  {
    [Embed(source="../../graphics/splash.png")]
    [Bindable]
    public var splashClass:Class;
    public var splashSrc:BitmapAsset;
    public var splash:BitmapData;
  
    private var anim:Number=0;
  
    public function Splash()
    {
      splashSrc = new splashClass() as BitmapAsset;
      splash = splashSrc.bitmapData;
    }
    
    public override function update():void
    {
      anim = anim + 0.02;
      if(anim > 1) anim--;
      if(game.input.anyKey)
      {
        game.changeState(Game.STATE_GAME);
        game.resetEntities();
      }
    }
    
    public override function render():void
    {
      game.renderer.backBuffer.copyPixels(splash, splash.rect, new Point(0,0));
      if(anim < 0.65)
        game.renderer.drawSprite("pressakey", 19, 82);
    }
  }
}