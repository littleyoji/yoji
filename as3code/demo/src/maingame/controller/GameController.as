package maingame.controller
{
	import com.nbu.framework.controller.BaseController;
	
	import maingame.Game;
	import maingame.scene.MainMenuScene;
	
	public class GameController extends BaseController
	{
		
		private var _view_mainMenu:MainMenuScene;
		
		private var _game:Game;
		public function GameController()
		{
			super();
		}
		public static function get instance():GameController
		{
			return BaseController.getInstance(GameController) as GameController;
		}
		public function get game():Game
		{
			return _game;
		}
		public function initGame(game:Game):void
		{
			//初始化界面等待游戏
			
			
			//这里游戏直接进入战斗场景
			_game = game;
			showScene('Battle');
		}
		
		/**
		 * 根据场景名创建相应场景并显示  
		 * @param SceneName
		 * 
		 */		
		private function showScene(sceneName:String):void
		{
			//sceneName = sceneName+"Controller";
//			if(ApplicationDomain.currentDomain.hasDefinition(sceneName))
//			{
//				hideMainMenu();
//				ApplicationDomain.currentDomain[sceneName].instance.start();
//			}
			if(sceneName=="Battle")
			{
				BattleController.instance.start();
			}
		}
		
		private function hideMainMenu():void
		{
			_view_mainMenu.removeFromParent();
		}
	}
}