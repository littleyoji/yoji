package maingame.scene.view
{
	import maingame.Game;
	import maingame.model.vo.BijouVO;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class BijouView extends Sprite
	{
		public static var CUBE_WIDTH:Number = 45;
		public static var CUBE_HEIGHT:Number = 45;
		/**
		 * 该宝石对应的数据 
		 */		
		private var _vo:BijouVO;
		/**
		 * 该宝石对应贴图 
		 */		
		private var _image:Image;
		
		/**
		 * 是否正在执行不可控动画 
		 */		
		private var _intween:Boolean = false;
		
		
		public function BijouView(vo:BijouVO)
		{
			_vo = vo;
			if(stage==null)
				addEventListener(Event.ADDED_TO_STAGE,init);
			else
			{
				init();
			}
		}
		public function get col():int
		{
			return _vo.column;
		}
		
		public function get row():int
		{
			return _vo.row;
		}
		
		public function get value():int
		{
			return _vo.value;
		}
		
		public function get intween():Boolean
		{
			return _intween;
		}
		
		public function get vo():BijouVO
		{
			return _vo;
		}
		/**
		 * 初始化该宝石 
		 * @param e
		 * 
		 */		
		private function init(e:Event=null):void
		{
			_vo.inGamegrid(this);
			
			setBijouValue(_vo.value);
		}
		
		/**
		 *  
		 * @param value
		 * 
		 */		
		private function setBijouValue(value:int):void
		{
			if(_image!=null)
			{
				//TODO:执行变形动画
				_image.dispose();
			}
			_image = new Image(Game.assets.getTexture('cube'+value));
			
			this.addChild(_image);
			//TODO: 执行棋子出现动画
		}
		
	}
}