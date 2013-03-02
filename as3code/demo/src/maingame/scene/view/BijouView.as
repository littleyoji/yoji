package maingame.scene.view
{
	import maingame.Game;
	import maingame.model.vo.BijouVO;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class BijouView extends Sprite
	{
		/**
		 * 该宝石对应的数据 
		 */		
		private var _vo:BijouVO;
		/**
		 * 该宝石对应贴图 
		 */		
		private var _image:Image;
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