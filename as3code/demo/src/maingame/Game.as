package maingame
{	
	import flash.ui.Keyboard;
	
	import maingame.controller.GameController;
	import maingame.scene.Scene;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.KeyboardEvent;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	/**
	 * 游戏核心类 
	 * @author xiaohan198
	 * 
	 */	
	public class Game extends Sprite
	{
		private var mCurrentScene:Scene;
		
		/**
		 * 资源管理器 
		 */		
		private static var sAssets:AssetManager;
		public function Game()
		{
		}
		
		public function start(background:Texture,assets:AssetManager):void
		{
			sAssets = assets;
			
			addChild(new Image(background));
			
			//处理加载器
			
			assets.loadQueue(
				function(ratio:Number):void{
					//处理进度条
					if(ratio==1)
					{
						//加载完成处理
						//显示场景
						Starling.juggler.delayCall(function():void
						{
						gameStart();
						},1.5);						
					}
				}
			);
			
			//addEventListener(Event.TRIGGERED,onButtonTriggred);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKey);
		}

		private function gameStart():void
		{
			//游戏初始化完成开始游戏
			
			GameController.instance.initGame(this);
		}
		
		/**
		 * 按键被按下
		 * @param event
		 * 
		 */		
		private function onKey(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.SPACE)
			{
				Starling.current.showStats = !Starling.current.showStats;
			}
			else
			{
				Starling.context.dispose();
			}
		}
		
		
		
		public static function get assets():AssetManager
		{
			return sAssets;
		}
	}
}