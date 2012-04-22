package Src.Gfx
{
  import mx.core.*;
  import mx.collections.*;
  import flash.display.*;
  import flash.geom.*
  import flash.text.*;

  public class Renderer
  {
    public var pixelSize:int;
    public var width:int;
    public var height:int;

    [Embed(source="../../graphics/spritesheet.png")]
    [Bindable]
    public var spriteSheetClass:Class;
    public var spriteSheetSrc:BitmapAsset;
    public var spriteSheet:BitmapData;

    // double buffer
    public var backBuffer:BitmapData;
    public var postBuffer:BitmapData;

    // colour to use to clear backbuffer with
    public var clearColor:uint = 0xff0a0d0d;
    
    // background
	public var bitmap:Bitmap;
	
    private var sprites:Object;

    private var fadeSpeed:Number;
    private var fade:Number;
    private var fadeCol:uint;
    
    public var camera:Camera;
    
    public var spriteDrawArray:Array;

    public function init(width:int, height:int, pixelSize:int):void
    {
      this.width = width;
      this.height = height;
      this.pixelSize = pixelSize;
	  
      bitmap = new Bitmap(new BitmapData(width, height, false, 0xAAAAAA ) );
      bitmap.scaleX = bitmap.scaleY = pixelSize;
	  
      spriteSheetSrc = new spriteSheetClass() as BitmapAsset;
      spriteSheet = spriteSheetSrc.bitmapData;

      backBuffer = new BitmapData(width, height, false);
      if(pixelSize != 1)
        postBuffer = new BitmapData(width*pixelSize,
                                    height*pixelSize, false);

      sprites = new Object();
      sprites["player"] = new SpriteDef(0,42,10,14,8,2);
      sprites["decoration"] = new SpriteDef(0,0,10,14,2,1);
      sprites["walls"] = new SpriteDef(0,14,10,14,3,1);
      sprites["objects"] = new SpriteDef(0,28,10,14,9,1);
      sprites["mapadvancer"] = new SpriteDef(10,28,10,14);
      sprites["marker"] = new SpriteDef(60,70,1,1);
      sprites["walltransition"] = new SpriteDef(0,84,10,14,5,3);
      sprites["ball"] = new SpriteDef(20,28,10,14);
      sprites["target"] = new SpriteDef(40,112,10,14,2);
      sprites["nonplayer"] = new SpriteDef(40,98,10,14,2);
      sprites["slug"] = new SpriteDef(0,70,10,14,2);
      sprites["destroyer"] = new SpriteDef(20,70,10,14,2);
      sprites["bigslug"] = new SpriteDef(30,0,30,18,3);
      sprites["snake"] = new SpriteDef(80,42,10,14,2);
      sprites["spinner"] = new SpriteDef(40,70,10,14,2);
      sprites["shadow"] = new SpriteDef(70,70,10,14,1);
      sprites["bigshadow"] = new SpriteDef(80,70,30,18,1);
      sprites["particle"] = new SpriteDef(70,98,2,2,4,3);
      sprites["bigparticle"] = new SpriteDef(80,98,5,5,1,1);

      fade = 0;
      fadeSpeed = 0.005;
      fadeCol = 0xff000000;
      camera = null;
      
      spriteDrawArray = new Array();
    }

    public function cls():void
    {      
      drawRect(backBuffer.rect, clearColor);      
    }
    
    private function sortOnLayer(a:SpriteDraw, b:SpriteDraw):int
    {
	    if(a.layer > b.layer) return 1;
      else return -1;
    }

    public function flip():void
    {
      if(spriteDrawArray != null)
      {
        spriteDrawArray.sort(sortOnLayer);
        for(var i:int = 0; i<spriteDrawArray.length; i++)
          renderSpriteDraw(spriteDrawArray[i]);
      }
    
      bitmap.bitmapData.fillRect( bitmap.bitmapData.rect, clearColor );
      bitmap.bitmapData.copyPixels(backBuffer, backBuffer.rect, new Point(0,0));
	  
      // TODO handle fill again
      
      spriteDrawArray = new Array();
    }
    
    public function doActualSpriteDraw(buffer:BitmapData, sprite:String, x:int, y:int, xFrame:int=0, yFrame:int=0):void
    {
      var spr:SpriteDef = getSpriteDef(sprite);
      if(!spr) return;
      buffer.copyPixels(spriteSheet, spr.getRect(xFrame, yFrame), new Point(x,y));
    }
    
    public function renderSpriteDraw(spriteDraw:SpriteDraw):void
    {
      var x:int = spriteDraw.x;
      var y:int = spriteDraw.y;
      if(camera)
      {
        x -= camera.pos.x;
        y -= camera.pos.y;
      }
      if(spriteDraw.bitmapData)
        backBuffer.copyPixels(spriteDraw.bitmapData, spriteDraw.bitmapData.rect, new Point(x,y));
      else
        doActualSpriteDraw(backBuffer, spriteDraw.sprite, spriteDraw.x, spriteDraw.y, spriteDraw.xFrame, spriteDraw.yFrame);
    }

    public function drawSprite(sprite:String, x:int, y:int, layer:Number=1000,
                                xFrame:int=0, yFrame:int=0):void
    {
      spriteDrawArray.push(new SpriteDraw(sprite, x, y, xFrame, yFrame, layer));
    }
    
    public function drawGraphic(bitmapData:BitmapData, x:int, y:int, layer:Number=1000):void
    {
      spriteDrawArray.push(new SpriteDraw("", x, y, 0, 0, layer, bitmapData));
    }
    
    public function getSpriteDef(sprite:String):SpriteDef
    {
      if(!sprites.hasOwnProperty(sprite))
      {
        trace("Sprite '"+sprite+"' not found!");
        return null;
      }
      return sprites[sprite];    
    }

    public function drawRect(rect:Rectangle, fillCol:uint):void
    {
      if(camera)
      {
        rect.x -= camera.pos.x;
        rect.y -= camera.pos.y;
      }
      backBuffer.fillRect(rect, fillCol);
    }

    public function drawSpriteText(str:String, x:int, y:int):void
    {
      if(camera)
      {
        x -= camera.pos.x;
        y -= camera.pos.y;
      }
      // If I want to use this I'll have to draw a font!
      /*str = str.toUpperCase();
      var i:int;
      for(i=0; i<str.length; i++)
      {
        var sprite:String = "font_regular";
        var frame:int = -1;
        var charCode:Number = str.charCodeAt(i);

        if(charCode >= 65 && charCode <= 90) // A to Z
          frame = charCode-65;
        if(charCode >= 48 && charCode <= 57) // 0 to 9
          frame = charCode-48+26;
        if(charCode >= 33 && charCode <= 47) // ! to /
        {
          sprite = "font_special";
          frame = charCode-33;
        }
        if(charCode >= 58 && charCode <= 64) // : to @
        {
          sprite = "font_special";
          frame = charCode-58+15;
        }
        if(frame != -1)
          drawSprite(sprite, x, y, frame);
        x += 8;
      }*/
    }

    public function drawFontText(str:String, x:int, y:int,
                                 center:Boolean = false,
                                 col:uint = 0xffffffff, sze:uint=20):void
    {
      if(camera)
      {
        x -= camera.pos.x;
        y -= camera.pos.y;
      }    
      var txt:TextField;
      var txtFormat:TextFormat;

      txtFormat = new TextFormat();
      txtFormat.size = sze;
      txtFormat.bold = true;

      txt = new TextField();
      txt.autoSize = TextFieldAutoSize.LEFT;

      txt.textColor = col;
      txt.text = str;
      txt.setTextFormat(txtFormat);

      if(center)
      {
        x -= txt.textWidth/2;
      }

      var matrix:Matrix = new Matrix();
      matrix.translate(x, y);
      backBuffer.draw(txt, matrix);
    }
    
    public function setCamera(camera:Camera=null):void
    {
      this.camera = camera;
    }

    public function startFade(col:uint, speed:Number):void
    {
      if(speed > 0)
        fade = 1;
      else
        fade = -1;
      fadeSpeed = speed;
      fadeCol = col;
    }

    public function update():void
    {
      if(fade > 0)
      {
        fade -= fadeSpeed;
        if(fade < 0)
          fade = 0;
      } else if(fade < 0)
      {
        fade -= fadeSpeed;
        if(fade > 0)
          fade = -0.001;
      }
    }
  }
}