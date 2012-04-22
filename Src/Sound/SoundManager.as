package Src.Sound
{
  import mx.core.*;
  import mx.collections.*;
  import flash.media.*;
  import flash.events.*;

  public class SoundManager
  {
    public var SOUND_ENABLED:Boolean = true;
    public var MUSIC_ENABLED:Boolean = true;

    [Embed(source="../../sound/ld23.mp3")]
    [Bindable]
    private var mp3Theme:Class;
    [Embed(source="../../sound/ld23_boss.mp3")]
    [Bindable]
    private var mp3Boss:Class;
    private var musicSounds:Object;
    private var channel:SoundChannel;
    public var currentTrack:String="";

    private var sounds:Object;

    public function SoundManager()
    {
      sounds = new Object()
      musicSounds = new Object();
    }
    
    private function addSynth(name:String, settings:String):void
    {
      var synth:SfxrSynth = new SfxrSynth();
      synth.setSettingsString(settings);
      synth.cacheMutations(5,0.01);
      sounds[name] = synth;
    }

    public function init():void
    {
      addSynth("increment", "0,,0.0156,0.367,0.2655,0.49,,,,,,0.5659,0.6049,,,,,,1,,,,,0.7");
      addSynth("decrement", "3,,0.0168,0.06,0.41,0.26,,-0.56,,,,,,,,,,,1,,,0.0497,,0.9");
      addSynth("bounceball", "0,,0.0843,,0.0956,0.33,,-0.54,,,,,,0.0674,,,,,1,,,0.0947,,0.7");
      addSynth("hitmonster", "3,,0.2,0.48,0.16,0.1608,,-0.4599,,,,,,,,,,,1,,,,,0.7");
      addSynth("unlocknoplayer", "1,,0.1654,,0.43,0.38,,0.1999,0.02,,,,,,,0.5851,,,1,,,,,0.7");
      addSynth("hittarget", "0,,0.0945,0.5721,0.2584,0.4887,,,,,,0.2521,0.6212,,,,,,1,,,,,0.7");
      addSynth("bossappear", "0,,0.36,0.3,0.62,0.4387,,-0.36,-0.78,,,,,0.1774,,0.6459,,,1,,,,,0.7");
      addSynth("ballpickup", "0,,0.0267,,0.18,0.29,,0.1999,,,,,,0.0957,,0.4438,,,1,,,,,0.7");
      addSynth("spinnerwall", "0,,0.0569,0.41,0.123,0.36,,,,,,,,,,,,,1,,,,,0.7");
      addSynth("destroy", "3,,0.21,0.3811,0.35,0.52,,0.1999,,,,,,,,,0.5831,-0.0469,1,,,,,0.7");

      // Do music
      musicSounds['theme'] = new mp3Theme() as SoundAsset;
      musicSounds['boss'] = new mp3Boss() as SoundAsset;
      playMusic('boss');
    }

    public function playSound(sound:String):void
    {
      if(!SOUND_ENABLED)
        return;
        
      if(!sounds.hasOwnProperty(sound))
      {
        trace("Sound '"+sound+"' not found!");
        return;
      }      

      sounds[sound].playCachedMutation();
    }

    public function playMusic(track:String, force:Boolean=false):void
    {
      if(currentTrack == track && !force)
        return;
      currentTrack = track;
      
      stopMusic();
      if(!MUSIC_ENABLED)
        return;
        
      if(!musicSounds.hasOwnProperty(track))
      {
        trace("Music '"+track+"' not found!");
        return;      
      }


      channel = musicSounds[currentTrack].play();
      setVol(0.4);
      channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
    }

    public function stopMusic():void
    {
      if(channel)
        channel.stop();
    }

    public function setVol(vol:Number):void
    {
      if(channel)
      {
        var transform:SoundTransform = channel.soundTransform;
        transform.volume = vol;
        channel.soundTransform = transform;
      }
    }

    private function soundCompleteHandler(event:Event):void
    {
      playMusic(currentTrack, true);
    }
    
  }
}