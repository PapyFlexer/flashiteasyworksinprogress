package com.flashiteasy.api.managers
{
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	
	import flash.errors.IOError;
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;



	/** Load a Sound from an MP3 file, then hold onto it and mediate playing and disposing of the object, and keep the several Sounds from interfering with one another.
	 *  This class stores each SoundManager instance in a collection keyed by the step name.
	 *
	 *  Do not call the Constructor directly to acquire a SoundManager. Instead, use getInstance.
	 */
	public class SoundManager
	{
		private static var allSounds:Object=new Object();

		public static function getInstance(name:String) : SoundManager
		{
			var soundMgr:SoundManager=allSounds[name];
			if (soundMgr == null)
			{
				soundMgr=new SoundManager(name);
				addSoundManager(soundMgr);
			}
			return soundMgr;
		}

		private static function addSoundManager(soundMgr:SoundManager) : void
		{
			allSounds[soundMgr.name]=soundMgr;
		}

		private static function removeSoundManager(name :  String) : void
		{
			var soundMgr:SoundManager=allSounds[name] as SoundManager;
			allSounds[name]=null;
			if (soundMgr != null)
			{
				soundMgr.dispose();
			}
		}

		public static function removeAllManagers() : void
		{
			var allSoundsTemp:Object=allSounds;
			allSounds=new Object();
			for (var prop:String in allSoundsTemp)
			{
				var soundMgr:SoundManager=allSoundsTemp[prop] as SoundManager;
				if (soundMgr != null)
				{
					soundMgr.dispose();
				}
			}
		}
		
		public static function listAllManagers() : Array
		{
			var a : Array = new Array;
			for (var prop : String in allSounds)
			{
				a.push(prop);
			}
			return a;
		}

		public static function stopManagers(exceptMgrName:String) : void
		{
			for (var prop:String in allSounds)
			{
				var soundMgr:SoundManager=allSounds[prop] as SoundManager;
				if (soundMgr != null && soundMgr.name != exceptMgrName)
				{
					soundMgr.stop();
				}
			}
		}

		private var mgrName:String;

		public function get name():String
		{
			return mgrName;
		}

		public var audio:Sound;
		public var audioChannel:SoundChannel;
		public var audioLoadStatus:String; // States: no audio, loading, loaded, ready. "loaded" means loaded enough to start playing, but possibly still loading more.

		private var rootPath:String;
		private var dataPath:String;
		private var mediaPath:String;
		public var audioFilename:String;
		private var onLoadHandler:Function; // Called When loading file is complete
		private var onAudioCompleteHandler:Function; // Called When playing audio is complete

		public var duration:Number;
		public var audioLastPosition:Number;

		private var volumeAdjustment:Number;

		/** Construct a SoundManager. Do not call this directy. Use the factory method getInstance instead. */
		function SoundManager( name:String ) : void
		{
			mgrName=name;
			audioLoadStatus="no audio";
			duration=0;
			audioLastPosition=0;
			volumeAdjustment=1;
		}

		/*
		 * Load the audio, then tigger the loading of the optional cue point xml file, and initialization of the controls.
		 *
		 * @param rootDirectory ...... Directory containing the config file.
		 * @param dataDirectory ...... Directory where cuepoint data is located. Expect the cuepoints file to be in the xml/cuepoints subdirectory.
		 * @param mediaDirectory ..... Directory where audio files are located.
		 * @param audioFile .......... Name of audio file with extension. Does not include path.
		 * @param onLoadHandler ...... Called once the audio is loaded, so the caller can start playing it.
		 */
		public function loadAudio(localPathToFile:String, onLoadHandler:Function, onAudioCompleteHandler:Function) : void
		{
			audioLoadStatus="loading";
			//Load the audio file.
			this.audioFilename=AbstractBootstrap.getInstance().getBaseUrl()+"/"+localPathToFile;
			this.onLoadHandler=onLoadHandler;
			this.onAudioCompleteHandler=onAudioCompleteHandler;
			

			var mySoundReq:URLRequest=new URLRequest( audioFilename );

			audio=new Sound();
			audio.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void
				{
					trace("SoundLoader.loadAudio ERROR!!!");
					trace(e);
				});
			
				// We can't afford to wait for whole audio to load, so wait until some of it is loaded.
				audio.addEventListener(ProgressEvent.PROGRESS, audioProgress1);
				audio.addEventListener(Event.COMPLETE, audioCompletelyLoaded);
			
				audio.load(mySoundReq);

		}

		// A sufficient portion of the audio has loaded, so start playing.
		private function audioProgress1(evt:ProgressEvent) : void
		{
			var loadPercent:Number=Math.round(100 * evt.bytesLoaded / evt.bytesTotal);
			if (loadPercent > 10 && audioLoadStatus == "loading")
			{ //TODO: Deduce a better threshold.
				var audioTemp:Sound=audio;
				audioTemp.removeEventListener(ProgressEvent.PROGRESS, audioProgress1);
				audioTemp.addEventListener(ProgressEvent.PROGRESS, audioProgress2);
				//audioLoaded();
			}
		}

		// As the audio continues to load, the duration lengthens, affecting the scrubber thumb position.
		private function audioProgress2(evt:ProgressEvent) : void
		{
			var loadPercent:Number=Math.round(100 * evt.bytesLoaded / evt.bytesTotal);
			if (audioLoadStatus == "loading" || audioLoadStatus == "loaded")
			{
				var audioTemp:Sound=audio;
				if (audioTemp != null)
				{
					duration=audioTemp.length / 1000; // Convert from milliseconds to seconds.
				}
			}
		}

		private function audioCompletelyLoaded(evt:Event) : void
		{
			var audioTemp:Sound=audio;
			if (audioTemp != null)
			{
				audioTemp.removeEventListener(Event.COMPLETE, audioCompletelyLoaded);
				audioTemp.removeEventListener(ProgressEvent.PROGRESS, audioProgress1);
				audioTemp.removeEventListener(ProgressEvent.PROGRESS, audioProgress2);
				duration=audioTemp.length / 1000;
			}
		}

		private function audioReady(evt:Event) : void
		{
			var audioTemp:Sound=audio;
			if (audioTemp != null)
			{
				audioTemp.removeEventListener(Event.COMPLETE, audioReady);
				audioLoaded();
			}
		}

		private function audioLoaded() : void
		{
			audioLoadStatus="loaded";

			var audioTemp:Sound=audio;
			if (audioTemp != null)
			{
				duration=audioTemp.length / 1000; // Convert from milliseconds to seconds.
				var audioChannelTemp:SoundChannel;
				audioChannelTemp=audioTemp.play();
				audioChannelTemp.stop();
				audioChannel=null;
				audioLastPosition=0;
				audioLoadStatus="ready";
				onLoadHandler();
			}
		}

		public function play() : void
		{
			pause();
			trace("--> Play " + name);
			audioChannel=audio.play(audioLastPosition);
			audioChannel.addEventListener(Event.SOUND_COMPLETE, onAudioCompleteHandler);
		}

		/** Seek into the audio to the given position in milliseconds. */
		public function seek(position:Number, resumePlay:Boolean) : void
		{
			trace("--> Seek(" + position + ") " + name);

			var tempAudioChannel:SoundChannel=audioChannel;
			var tempSoundTransform:SoundTransform = audioChannel.soundTransform;
			audioChannel=null;
			if (tempAudioChannel != null)
			{
				tempAudioChannel.stop();
				tempAudioChannel.removeEventListener(Event.SOUND_COMPLETE, onAudioCompleteHandler);
			}
			audioLastPosition=position;

			if (resumePlay)
			{
				tempAudioChannel=audio.play(audioLastPosition);
				tempAudioChannel.addEventListener(Event.SOUND_COMPLETE, onAudioCompleteHandler);
				tempAudioChannel.soundTransform = tempSoundTransform;
				audioChannel=tempAudioChannel;
			}
		}

		public function pause() : void
		{
			trace("--> Pause " + name);
			if (audioChannel != null)
			{
				audioLastPosition=audioChannel.position;
				audioChannel.stop();
				audioChannel.removeEventListener(Event.SOUND_COMPLETE, onAudioCompleteHandler);
				audioChannel=null;
			}
		}

		public function stop() : void
		{
			trace("--> Stop " + name);
			audioLastPosition=0;
			if (audioChannel != null)
			{
				audioChannel.stop();
				audioChannel.removeEventListener(Event.SOUND_COMPLETE, onAudioCompleteHandler);
				audioChannel=null;
			}
		}

		/** Elapsed time of audio in seconds. */
		public function get audioElapsed():Number
		{
			if (audioLoadStatus == "ready")
			{
				if (audioChannel != null)
				{
					return audioChannel.position / 1000.0;
				}
				else
				{
					return audioLastPosition / 1000.0;
				}
			}
			else
			{
				return 0;
			}
		}

		/** Set the audio volume to a number between zero (mute) and one (loud). */
		public function setVolume(volume:Number, soundTransform:SoundTransform=null) : void
		{
			if (audioChannel != null)
			{
				if (soundTransform == null)
				{
					soundTransform=new SoundTransform();
				}
				if (volumeAdjustment != 1.0)
				{
					trace("setVolume using volume adjustment of " + volumeAdjustment);
				}
				soundTransform.volume=volume * volumeAdjustment;
				audioChannel.soundTransform=soundTransform;
			}
		}

		public function unloadAudio() : void
		{
			dispose();
		}

		private function dispose() : void
		{
			audioLoadStatus="no audio";
			var audioTemp:Sound=audio;
			audio=null;
			stop();
			if (audioTemp != null)
			{
				try
				{
					audioTemp.close();
				}
				catch (error:IOError)
				{
					trace("Error: Couldn't close audio stream: " + error.message);
				}

			}
		}

	}
}
