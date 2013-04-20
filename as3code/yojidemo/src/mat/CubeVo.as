package mat
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	public class CubeVo extends Sprite
	{
		public static const cube_size:Number = 92;
		/**
		 * 该资源的视图信息 
		 */		
		private var _view:Sprite;
		
		/**
		 * 所在行 宝石无法自行管理自己的行和列 
		 */		
		private var _col:int;
		
		/**
		 * 所在列
		 */		
		private var _row:int;
		/**
		 * 该宝石的值 
		 */		
		private var _value:int;
		
		private var _intween:Boolean;
		public function CubeVo(tvalue:int = 1)
		{
			value = tvalue;
		}
		
		public function get view():Sprite
		{
			return _view;
		}
		
		public function get col():int
		{
			return _col;
		}
		
		public function get row():int
		{
			return _row;
		}
		
		public function get intween():Boolean
		{
			return _intween;
		}
		
		/**
		 * 设置动画 
		 * @param bool
		 * 
		 */		
		public function set intween(bool:Boolean):void
		{
			_intween = bool;	
		}
		/**
		 * 只公开 position set方法，用于移动棋子 
		 * @param col
		 * @param row
		 * 
		 */		
		public function position(col:int,row:int):void
		{
			_col = col;
			_row = row;
		}
		/**
		 * 设置值  
		 * @param index
		 * 
		 */		
		public function set value(index:int):void
		{
			if(index!=0)
			{
				var cl:Class = getDefinitionByName('cube'+index) as Class;
				if(_view!=null)
				{
					if(_view.parent!=null)
					{
						this.removeChild(_view);
					}
				}
				_view = new cl();
				this.addChild(_view);
				_value = index;
			}
		}
		
		public function get value():int
		{
			return _value;
		}
		
		public function dispose():void
		{
			if(_view!=null)
			{
				TweenLite.to(this,0.4,{alpha:0,
					onComplete:clearself
				});
				
			}
		}
		
		private function clearself():void
		{
			if(this.parent!=null)
			{
				(this.parent as Sprite).removeChild(this);
			}
		}
	}
}