package Src.FE
{
  public class CreditItem
  {    
    public var str:String;
    public var sprite:String;
    public var xframe:int;
    public var yframe:int;
    public function CreditItem(str:String, sprite:String="", xframe:int=0, yframe:int=0)
    {
      this.str = str;
      this.sprite = sprite;
      this.xframe = xframe;
      this.yframe = yframe;
    }
  }
}
