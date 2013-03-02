package maingame.scene
{
	import maingame.Game;
	import maingame.scene.view.BattleCanvas;
	import maingame.scene.view.GridCanvas;
	
	import starling.display.Image;
	import starling.events.Event;

	public class BattleScene extends Scene
	{
		private var _canvas_battle:BattleCanvas;
		
		private var _canvas_grid:GridCanvas;
		
		private var _bg_battle:Image;
		
		private var _bg_grid:Image;
		
		public function get canvas_grid():GridCanvas
		{
			return _canvas_grid;
		}
		
		public function get canvas_battle():BattleCanvas
		{
			return _canvas_battle;
		}
		public function BattleScene()
		{
			super();
			if(stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		/**
		 *  
		 * @param event
		 * 
		 */		
		private function init(event:Event=null):void
		{
			if(_canvas_battle==null)
			{
				
			}
			if(_canvas_grid==null)
			{
				_canvas_grid = new GridCanvas();
			}
			if(_bg_battle==null)
			{
				_bg_battle = new Image(Game.assets.getTexture("ground"));
			}
			if(_bg_grid==null)
			{
				_bg_grid = new Image(Game.assets.getTexture("frame"));
			}
			_bg_grid.y = _bg_battle.height;
			_canvas_grid.y = _bg_battle.height;
			this.addChild(_bg_grid);
			this.addChild(_bg_battle);
		}
		
		/**
		 * 设置当前的填充宝石 
		 * 
		 */		
		public function setMap():void
		{
			
		}
	}
}