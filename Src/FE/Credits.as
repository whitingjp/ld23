package Src.FE
{
  import mx.core.*;
  import mx.collections.*;
  import flash.display.*;
  import flash.geom.*
  import Src.*;
  import Src.Gfx.*;

  public class Credits extends Screen
  {
    public var items:Array;
    public var pos:int;
    public var timer:Number;
    public function Credits()
    {
      items = new Array();
      items.push(new CreditItem("ni0a nueve"));
      items.push(new CreditItem("by"));
      items.push(new CreditItem("jonathan whiting"));
      items.push(new CreditItem("staring"));
      items.push(new CreditItem("ni0a nueve","player", 4));
      items.push(new CreditItem("globby","slug", 1));
      items.push(new CreditItem("woozy","spinner"));
      items.push(new CreditItem("henrietta","credit_bosses"));
      items.push(new CreditItem("simone","credit_bosses",1));
      items.push(new CreditItem("and"));
      items.push(new CreditItem("dr ball","ball"));
      items.push(new CreditItem("cheers xx"));
      items.push(new CreditItem(""));
      pos=0;
      timer=0;
    }
    
    public override function update():void
    {
      timer += 0.005;
      if(timer > 1)
      {
        pos=(pos+1)%items.length;
        timer--;
      }
      if(false)
      {
        game.changeState(Game.STATE_GAME);
        game.resetEntities();
      }
    }
    
    public override function render():void
    {
      game.renderer.drawSprite("youwin", 19, 9);
      
      var xpos:Number = 0;
      if(timer < 0.2)
      {
        xpos = (timer*5);
        xpos *= -100;
        xpos += 100;
      } else if(timer > 0.8)
      {
        xpos = (timer-0.8)*5;
        xpos *= -100;
      } else
      {
        xpos = 0;
      }
      game.renderer.drawSpriteText(items[pos].str, 45+xpos, 45);
      
      var spriteDef:SpriteDef = game.renderer.getSpriteDef(items[pos].sprite);
      if(spriteDef)
      {
        var drawX:int = 45-spriteDef.width/2;
        game.renderer.drawSprite(items[pos].sprite, drawX+xpos, 60, 1000, items[pos].xframe, items[pos].yframe);
      }
    }
  }
}