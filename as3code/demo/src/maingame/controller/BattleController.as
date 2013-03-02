package maingame.controller
{
	import com.nbu.framework.controller.BaseController;
	
	import maingame.model.DataConfigModel;
	import maingame.model.UserModel;
	import maingame.model.vo.BattleInfoVO;
	import maingame.model.vo.GridVO;
	import maingame.model.vo.MapVO;
	import maingame.model.vo.SceneConfigVO;
	import maingame.model.vo.SkillVO;
	import maingame.scene.BattleScene;
	import maingame.scene.view.BattleCanvas;
	import maingame.scene.view.GridCanvas;

	public class BattleController extends BaseController
	{
		private static var _test_user_data:Object={"HP":300,"ATK":200,"DEF":200,"skillList":[1,1,1,1,1]};
		
		private static var _test_en_data:Object={"HP":300,"ATK":200,"DEF":200,"skillList":[1,1,1,1,1]};

		private var _view_battle:BattleScene;
		
		private var _canvas_battle:BattleCanvas;
		
		private var _canvas_grid:GridCanvas;
		/**
		 * 妖姬消除二维图 
		 */		
		private var _maps:MapVO;
		
		/**
		 * 消除逻辑图 
		 */		
		private var _grid:GridVO;
		
		/**
		 * 宝石区域列数 
		 */		
		private var _game_gird_c:int = 6;
		
		/**
		 * 宝石区域行数 
		 */		
		private var _game_gird_r:int = 6;
		/**
		 * 当前场景配置信息 
		 */		
		private var _now_sceneConfig:SceneConfigVO;
		
		/**
		 * 当前用户战斗信息 
		 */		
		private var _playerBattleInfo:BattleInfoVO;
		
		/**
		 * 当前敌人战斗信息 
		 */		
		private var _enemyBattleInfo:BattleInfoVO;
		
		/**
		 * 当前队列中的技能 
		 */		
		private var _arr_skill:Vector.<SkillVO>;
		
		
		public function BattleController()
		{
			super();
		}
		
		public static function get instance():BattleController
		{
			return BaseController.getInstance(BattleController) as BattleController;
		}
		
		public function start():void
		{
			trace('111111');
			if(_view_battle==null)
			{
				_view_battle = new BattleScene();
			}
			GameController.instance.game.addChild(_view_battle);
			
			resetSkills();
			resetRoles();
			resetBattle();
			
			_playerBattleInfo = new BattleInfoVO();
			_enemyBattleInfo = new BattleInfoVO();
			_playerBattleInfo.setData(_test_user_data);
			_enemyBattleInfo.setData(_test_en_data);
			
		}
		/**
		 * 重置所有技能以及资源 
		 * 
		 */		
		public function resetSkills():void
		{
			
		}
		/**
		 * 重置角色数据以及资源 
		 * 
		 */		
		public function resetRoles():void
		{
			
		}
		/**
		 * 清除战斗背景以及场景内特效 
		 * 
		 */		
		public function resetBattle():void
		{
			
		}
		/**
		 * 根据场景配置以及用户信息 
		 * 
		 */		
		public function showScene(sceneInfo:SceneConfigVO):void
		{
			//以上均参考假数据
			_maps = DataConfigModel.instance.getSceneById(UserModel.instance.current_sceneId).scene_map;
			_grid = new GridVO();
			_grid.newGrid(_maps);
			_canvas_battle = _view_battle.canvas_battle;
			_canvas_grid = _view_battle.canvas_grid;
			_canvas_grid.initGameGrid(_game_gird_c,_game_gird_r,_grid);
		}
	}
}