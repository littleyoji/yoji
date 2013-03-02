package
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import maingame.Game;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	import starling.utils.formatString;
	
	
	[swf(width="380",height="580",frameRate="30",backgroundColor="#000000")]
	public class cubedemo extends Sprite
	{
		[Embed(source="../system/startup.jpg")]
		private static var Background:Class;
	
		[Embed(source="../system/startupHD.jpg")]
		private static var BackgroundHD:Class;
		private var mStarling:Starling;
		private var background:Bitmap;
		private var assets:AssetManager;
		private var scaleFactor:int;
		
		private static var _game:Game;
		public function cubedemo()
		{
			super();
			
			// 支持 autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			
			
			var stageWidth:int  = 380;
			var stageHeight:int = 580;
			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
			
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = !iOS;  // not necessary on iOS. Saves a lot of memory!
			
			// create a suitable viewport for the screen size
			// 
			// we develop the game in a *fixed* coordinate system of 320x480; the game might 
			// then run on a device with a different resolution; for that case, we zoom the 
			// viewPort to the optimal size for any display and load the optimal textures.
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight),
				new Rectangle(0, 0, stageWidth, stageHeight), 
				 
				ScaleMode.SHOW_ALL, iOS);
			
			// create the AssetManager, which handles all required assets for this resolution
			
			scaleFactor = viewPort.width < 480 ? 1 : 2; // midway between 320 and 640
			var appDir:File = File.applicationDirectory;
			assets = new AssetManager(scaleFactor);
			
			assets.verbose = Capabilities.isDebugger;
			assets.enqueue(
				appDir.resolvePath("assets/audio"),
				//appDir.resolvePath(formatString("assets/textures/{0}x", scaleFactor))
				//,appDir.resolvePath(formatString("assets/textures/{0}x", scaleFactor))
				appDir.resolvePath(formatString("assets/textures/1x", scaleFactor))
			);
			viewPort.x = 0;
			viewPort.y = 0;
			background = scaleFactor == 1 ? new Background() : new BackgroundHD();
			Background = BackgroundHD = null; // no longer needed!
			
			background.x = viewPort.x;
			background.y = viewPort.y;
			background.width  = viewPort.width;
			background.height = viewPort.height;
			background.smoothing = true;
			addChild(background);
			
			mStarling = new Starling(Game,stage,viewPort);
			mStarling.stage.stageWidth = stageWidth;
			mStarling.stage.stageHeight = stageHeight;
			mStarling.simulateMultitouch  = true;
			mStarling.enableErrorChecking = true;
			
			
			mStarling.addEventListener(starling.events.Event.ROOT_CREATED,initStarling);
			
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE,
				function(e:*):void
				{
					mStarling.start();
				}
			);
			
			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.DEACTIVATE, function (e:*):void { mStarling.stop(); });
			
		}
		
		public function get game():Game
		{
			return _game;
		}
		
		/**
		 * 根节点初始化 
		 * @param e
		 * 
		 */		
		private function initStarling(e:starling.events.Event):void
		{
			removeChild(background);
			
			_game = mStarling.root as Game;
			var bgTexture:Texture = Texture.fromBitmap(background,false,false,scaleFactor);
			_game.start(bgTexture,assets);
			
			mStarling.start();
		}
	}
}